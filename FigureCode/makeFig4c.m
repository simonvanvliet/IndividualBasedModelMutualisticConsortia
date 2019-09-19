%makes Figure 4c
%% DATA SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = struct;
data.filenames                    = { ...
                                    'dataFig4c.mat' ; ... 
                                  };
                           
% FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = struct;
fg.filename                     = 'Fig4c';
fg.save                         = 1;

%% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.LineStyle                    = {'none'}; % '-' 'none'
fg.LineWidth                    = {1.5}; 
fg.Color                        = {[0.0 0.0 0.0 0.2]}; % 4th number is transparency
fg.Marker                       = {'none'}; % '0' 'none'
fg.MarkerSize                   = {4}; % 6
fg.MarkerFaceColor              = {'none'}; % 'none'
fg.MarkerEdgeColor              = {[0.6 0.1 0.1]}; % 'none'
fg.ColorMap                     = 'EastOutside';

%% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.axes.width                   = 5.2; % width of axes in cm
fg.axes.height                  = 3.8; % height of axes in cm
fg.axes.offset                  = [.9 .4 0.2 1]; % offset between axis and figure in cm [bottom left top right]
fg.axes.lineWidth               = 1;

fg.axes.xlabel                  = ['leakage/growth (log_{10})'];
fg.axes.ylabel                  = ['uptake/diffusion (log_{10})']; 
fg.axes.xlabel_offset           = [ 0.0  0.0];
fg.axes.ylabel_offset           = [ 0.0  0.0];


fg.axes.xtickVal           = -4:-1;
fg.axes.ytickVal           = -3:0;

%% LOAD DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(data.filenames{1});


%get values of strains
settings=SteadyState_2D_SettingsRevision;
D  = settings.D0/(settings.cellSpacing)^2;
Deff =(settings.D0/(settings.cellSpacing)^2)...
    *(1-settings.rho)/(1+settings.rho/2)....
    *(1-settings.rho)/settings.rho;

rlNormRange = rlMat(1,:);
ruNormRange = ruMat(:,1)/D;

ruRangeLog=[log10(min(ruNormRange))+1 log10(max(ruNormRange))];%EDITED 25.04.2019 TO  ISUALIZE ONLY UP TO LOG -4, remove +1 otherwise
rlRangeLog=[log10(min(rlNormRange))+1 log10(max(rlNormRange))];


%extract real rates
ruPro=settings.ru/sqrt(settings.delta_u);
rlPro=settings.rl/sqrt(settings.delta_l);

ruTrp=settings.ru*sqrt(settings.delta_u);
rlTrp=settings.rl*sqrt(settings.delta_l);

DPro=Deff/sqrt(settings.delta_D);
DTrp=Deff*sqrt(settings.delta_D);


rlRange=log10(max(rlNormRange))-log10(min(rlNormRange));
ruRange=log10(max(ruNormRange))-log10(min(ruNormRange));

rlOffset=log10(min(rlNormRange));
ruOffset=log10(min(ruNormRange));


ruProNorm=(ruPro./DPro);
ruTrpNorm=(ruTrp./DTrp);
rlProNorm=(rlPro);
rlTrpNorm=(rlTrp);

%set plot options
myCOLORS;
rC=purple*1.1; 
gC=yellow; 

%plot figure
hFig                            = figure('MenuBar','none', 'Name', fg.filename, 'NumberTitle', 'off');
%plot growth range
dataToPlot = GRsimpleFine;
imagesc(rlRangeLog,ruRangeLog,dataToPlot);

%hold on markers for dPro and dTry
MSize=12;
hold on
plot(log10(rlProNorm),log10(ruProNorm),'o','MarkerFaceColor','none','MarkerEdgeColor',rC,'MarkerSize',MSize,'LineWidth',2)
plot(log10(rlTrpNorm),log10(ruTrpNorm),'o','MarkerFaceColor','none','MarkerEdgeColor',gC,'MarkerSize',MSize,'LineWidth',2)
hold off
axis xy
axis square

set(gca,'XTick',fg.axes.xtickVal,'YTick',fg.axes.ytickVal)
xlabel([fg.axes.xlabel])
ylabel([fg.axes.ylabel])

%set colormap
cmap_name='plasma';
cmap = csvread([cmap_name '.csv']);

colormap(cmap(35:10:256,:))
%cividis viridis magma plasma inferno
c1=colorbar('eastoutside') ;  ...'EastOutside');
c1.Label.String='growth range [\mum]';
c1.Label.FontSize=9;
c1.Ticks=0:10:60;

caxis([0 60])



%% ADJUST FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fg.figureWidth                  = fg.axes.width+fg.axes.offset(2)+fg.axes.offset(4);
fg.figureHeight                 = fg.axes.height+fg.axes.offset(1)+fg.axes.offset(3);
hFig.Units                      = 'centimeter';
hFig.Position                   = [1 1 fg.figureWidth fg.figureHeight];

hFig.PaperUnits                 = 'centimeters';
hFig.PaperSize                  = [fg.figureWidth fg.figureHeight];
% hFig.Renderer                   = 'Painters'; % for saving alpha (patches) as pdf 

hAx                             = hFig.Children(2);
hAx.Units                       = 'centimeter';
hAx.Box                         = 'on';
hAx.LineWidth                   = fg.axes.lineWidth;
hAx.Position                    = [fg.axes.offset(2) fg.axes.offset(1) fg.axes.width fg.axes.height];
%hAx.YScale                      = 'linear';
hAx.TickLength                  = [0.015 0.015];
hAx.XMinorTick                  = 'off';
hAx.YMinorTick                  = 'off'; 
hAx.FontName                    = 'Arial';
hAx.FontWeight                  = 'normal';
hAx.FontSize                    = 7;

hAx.XLabel.String               = fg.axes.xlabel;
hAx.XLabel.Units                = 'centimeter';
hAx.XLabel.FontName             = 'Arial';
hAx.XLabel.FontWeight           = 'normal';
hAx.XLabel.FontSize             = 9;
hAx.XLabel.Position             = [fg.axes.xlabel_offset 0] + hAx.XLabel.Position;
%hAx.XLim                        = fg.axes.xlim;
%hAx.XTick                       = fg.axes.xticks;
%hAx.XTickLabel                  = fg.axes.xticksLabel;

hAx.YLabel.String               = fg.axes.ylabel;
hAx.YLabel.Units                = 'centimeter';
hAx.YLabel.FontName             = 'Arial';
hAx.YLabel.FontWeight           = 'normal';
hAx.YLabel.FontSize             = 9;
hAx.YLabel.Position             = [fg.axes.ylabel_offset 0] + hAx.YLabel.Position;
%hAx.YTick                       = fg.axes.yticks;
%hAx.YLim                        = fg.axes.ylim;
%hAx.YTickLabel                  = fg.axes.yticksLabel;


%% SAVE FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if fg.save
    saveas( hFig, [fg.filename '_' cmap_name '.pdf'] );
    disp([' * Saved figure in ' fg.filename '.pdf']);
end
