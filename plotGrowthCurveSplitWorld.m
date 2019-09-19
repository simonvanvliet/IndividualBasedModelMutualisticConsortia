function plotGrowthCurveSplitWorld(muX,settings,titleName)


if isempty(settings)
    gridSizeCells=length(muX);
else
    gridSizeCells=settings.gridSizeCells;
end


ctype=[0 0 0;190,186,218;255,255,179;251,128,114;141,211,199;]/255;

midPoint=floor(gridSizeCells/2);

plot(1:midPoint,muX(1:midPoint),'-o','LineWidth',3,'Color',ctype(4,:),'MarkerSize',6,'MarkerFaceColor',ctype(4,:),'MarkerEdgeColor','none')
hold on
plot(midPoint+1:gridSizeCells,muX(midPoint+1:end),'-o','LineWidth',3,'Color',ctype(5,:),'MarkerSize',6,'MarkerFaceColor',ctype(5,:),'MarkerEdgeColor','none');
axis([0 gridSizeCells+1 0 ceil(max(muX)/0.1)*0.1])
set(gca,'YTick',[0 ceil(max(muX)/0.1)*0.1],'XTick',[1 midPoint+0.5 gridSizeCells],'XTickLabel',[-midPoint 0 midPoint])
h=line([midPoint midPoint]+0.5,[0 ceil(max(muX)/0.1)*0.1]);
set(h,'LineWidth',2,'Color','k')
ylabel('Growth Rate')
text(1,floor(max(muX)/0.1)*0.1,'delta-Try','FontSize',14,'FontWeight','Bold')
text(gridSizeCells,floor(max(muX)/0.1)*0.1,'delta-Pro','FontSize',14,'FontWeight','Bold','HorizontalAlignment','right')

title(titleName)