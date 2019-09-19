function [InterfaceGrowthRatio,TotalGrowthRatio,GrowthRangeRatio,InterfaceGrowthMean,TotalGrowthMean,GrowthRangeMean] = characterizeGrowthProfileSplitWorld(muX,settings)

gridSizeCells=settings.gridSizeCells;

midPoint=floor(gridSizeCells/2);

muTry=muX(1:midPoint);
muPro=muX(midPoint+1:end);

InterfaceGrowthRatio=muTry(end)/muPro(1);
TotalGrowthRatio=sum(muTry)/sum(muPro);

InterfaceGrowthMean=(muTry(end)+muPro(1))/2;
TotalGrowthMean=(sum(muTry)+sum(muPro))/2;

muTryHM=sum(muTry>(0.5*muTry(end)));
muProHM=sum(muPro>(0.5*muPro(1)));
GrowthRangeRatio=muTryHM/muProHM;
GrowthRangeMean=(muTryHM+muProHM)/2;

end

