%This code compares chamber growth rate for real data and randomized arrangements
%
% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 12.6.2018
% Last update: 12.9.2018

%% SETTINGS
% SET DEBUG
DEBUG = 0; %(turns on debug for subfunction that calcs interaction range and growth range)

%SET number of randomization
numRand = 10;

% load default settings
settings  =  SteadyState_2D_SettingsRevision;

% load experimental spatial arrangements
load('experimentalSpatialArrangements.mat')

%preallocate memory
numPos  =  size(gridCellTypeStack, 3);

%preallocate memory
muRand = nan(numRand,numPos);
muReal = nan(1,numPos);
muRandDT = nan(numRand,numPos);
muRandDP = nan(numRand,numPos);
muRealDT = nan(1,numPos);
muRealDP = nan(1,numPos);

%loop chambers
for rr  =  1:numPos
    
    %get fraction of DT of current chamber
    currChamber = squeeze(gridCellTypeStack(:,:,rr));
    fracDT = sum(sum(currChamber == 0))/sum(sum(currChamber == 0 | currChamber == 1));
    
    locSet = settings;

    %Solve on real spatial arrangement
    locSet.gridScaling = locSet.gridScalingBase;
    [initialCondition] = SteadyState_2D_InitGrid_2018(locSet,'ProvidedGrid',currChamber);
    
    %SOLVE INITIAL STEADY STATE, use grid refinement until solution converges
    [output,~,~,~] = SteadyState_2D_RefineGrid_2018(locSet,initialCondition);
    muGrid = output.mu; %matrix with growth rates for each cell
    typeGrid = output.gridCellType;
    
    %extract fraction and average growth
    muReal(1,rr) = mean(muGrid(:));
    %split growth by type
    muRealDT(1,rr) = mean(muGrid(typeGrid == 0));
    muRealDP(1,rr) = mean(muGrid(typeGrid == 1));
    
    %perform randomization
    for dd = 1:numRand
        
        locSet = settings;
        locSet.initFracType1 = fracDT; %creates random pattern with current fraction of DT
        
        %% solve t0
        %initialize grid, use random grid with same global fraction DT
        locSet.gridScaling = locSet.gridScalingBase;
        locSet.randNumFeedInitGrid = dd*now;
        [initialCondition] = SteadyState_2D_InitGrid_2018(locSet,'Random');
        
        %SOLVE INITIAL STEADY STATE, use grid refinement until solution converges
        [output,~,~,~] = SteadyState_2D_RefineGrid_2018(locSet,initialCondition);
        muGrid = output.mu; %matrix with growth rates for each cell
        typeGrid = output.gridCellType;
        
        %extract fraction and average growth
        muRand(dd, rr) = mean(muGrid(:));
        %split growth by type
        muRandDT(dd, rr) = mean(muGrid(typeGrid == 0));
        muRandDP(dd, rr) = mean(muGrid(typeGrid == 1));
        
    end
end

%calculate mean growth over randomizations
muRand_mean = mean(muRand);
xVec = 1:numPos;
save('dataFig5e.mat',  'muRand_mean', 'xVec', 'muReal', 'settings')




