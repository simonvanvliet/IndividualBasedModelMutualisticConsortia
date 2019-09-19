function [ru,delta_u]=find_ru_toUse(settings,targetRangeP,targetRangeT,toPlot)
%Calculates the needed value of uptake rates to get growth range targetRangeP and targetRangeT for DP and DT strains

%calculate GR fir large range of ru values
Deff=(settings.D0/(settings.cellSpacing)^2)...
    *(1-settings.rho)/(1+settings.rho/2)....
    *(1-settings.rho)/settings.rho;

rlP=settings.rl/sqrt(settings.delta_l);
rlT=settings.rl*sqrt(settings.delta_l);

DP=Deff/sqrt(settings.delta_D);
DT=Deff*sqrt(settings.delta_D);

ruRangeLog=[2 5];
ruFine=logspace(ruRangeLog(1),ruRangeLog(2),1000);

r0P = sqrt(DP ./ ((ruFine + rlP)));
r0T = sqrt(DT ./ ((ruFine + rlT)));

[GRsimpleP,GRfullP] = GR_analytical(r0P, settings.Iconst2, rlP);
[GRsimpleT,GRfullT] = GR_analytical(r0T, settings.Iconst1, rlT);

%SET: SELECT FULL OR SIMPLE RANGE
rangeP = GRsimpleP;
rangeT = GRsimpleT;

%find ru that is closest to desired value
[~,inP]=min(abs(rangeP-targetRangeP));
[~,inT]=min(abs(rangeT-targetRangeT));
    
ruP=ruFine(inP);
ruT=ruFine(inT);
ru=sqrt(ruP*ruT);
delta_u=ruT/ruP;

ruOut=sprintf('ru_P= %#.2g, ru_T= %#.2g, ru= %#.2g, 1/delta_u= %#.2g\n',...
    ruP,ruP,ru,1/delta_u);
fprintf(ruOut)


if toPlot
    figure
    maxY=100;
    semilogx(ruFine,rangeP,'-g',ruFine,rangeT,'-r','LineWidth',2);
    hold on
    line(10.^ruRangeLog,[targetRangeP targetRangeP],'LineStyle',':','Color','k','LineWidth',2)
    line([ruP ruP],[0 maxY],'LineStyle',':','Color','g','LineWidth',2)
    line([ruT ruT],[0 maxY],'LineStyle',':','Color','r','LineWidth',2)
    xlim(10.^ruRangeLog)
    ylim([0 maxY]);
    xlabel('ru')
    ylabel('range [grid units]')

    title(ruOut);
    
end


