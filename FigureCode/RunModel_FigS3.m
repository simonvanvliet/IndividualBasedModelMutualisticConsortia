%This code can be used to test how interaction range depends on cluster size
%It changes expected cluster size and calculates interaction range

% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 12.6.2018
% Last update: 12.6.2018

%% SETTINGS
% SET DEBUG
DEBUG = 0; %(turns on debug for subfunction that calcs interaction range and growth range)
PLOT_ARRANGEMENT = 0;
correlationType  =  'Spearman';

% load default settings
settings = SteadyState_2D_SettingsRevision;

% SET Cluster size
clusterSizeVec = [0 1 2 3 4 5 10 15 20 30 40 50 60 70 80]; %cluster size of artificial data (#of replacement rounds)

% SET CALIBRATION OPTIONS
numChambers = 100; %number of chambers to analyze. With default settings 400 cell per chamer are used

radiusVec = 1:0.5:20; %radia (in cell widths) at which neighborhood is evaluated
edgeToIgnore = 10; %number of grid sites (cells) at edge to exclude from analysis
initialFractionFreq = [0.5 0.5]; %set start and end point of intial frequency of type 1 used to initialize grid


%% %%% START OF CODE %%%%%%
%loop parameters to scan
numClusterSizes = length(clusterSizeVec);

%initOutput
interactionRangePro = nan(numClusterSizes,1);
interactionRangeTrp = nan(numClusterSizes,1);
inputGrid = cell(numClusterSizes,1);

RhoSqPro = cell(numClusterSizes,1);
RhoSqTrp = cell(numClusterSizes,1);

for nn = 1:numClusterSizes %loop parameter values
    %create artificial spatial arrangement with given cluster size
    clusterSize = clusterSizeVec(nn);
    gridCellTypeStack = SteadyState_2D_Calc_CalibrationImagesArtificial(settings,numChambers,clusterSize,initialFractionFreq);
    
    localsettings = settings;
    
    %Compute interaction and growth range
    functionOutput = SteadyState_2D_Calc_InteractionGrowthRange(localsettings,...
        gridCellTypeStack,edgeToIgnore,radiusVec,DEBUG, 1, correlationType);
    
    %store output
    interactionRangePro(nn) = functionOutput.interactionRangeDP;
    interactionRangeTrp(nn) = functionOutput.interactionRangeDT;
    
    RhoSqPro{nn} = functionOutput.rhoDPAtRadius;
    RhoSqTrp{nn} = functionOutput.rhoDTAtRadius;
    inputGrid{nn} = gridCellTypeStack;
end


%% plot spatial arrangements
if PLOT_ARRANGEMENT
figure(1112)
for nn = 1:numClusterSizes
    for pp = 1:numChambers
        subplot(numClusterSizes,numChambers,(nn-1)*numChambers+pp)
        imagesc(squeeze(inputGrid{nn}(:,:,pp)))
        set(gca,'XTickLabel',{''},'YTickLabel',{''})
        axis image
        if pp == 1; title(sprintf('clustersize  =  %.2g',clusterSizeVec(nn))); end
    end
end
end


intRangeTrpum = interactionRangeTrp*settings.cellSpacing;
intRangeProum = interactionRangePro*settings.cellSpacing;

save('dataFigS3.mat',  'RhoSqPro', 'RhoSqTrp', 'clusterSizeVec', 'settings','intRangeTrpum','intRangeProum', 'radiusVec', 'numClusterSizes')

