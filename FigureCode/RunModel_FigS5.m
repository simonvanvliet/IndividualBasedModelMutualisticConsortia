%This code calculates community growth rate as function of growth range.
%uptake rates are changed to obtain desired growth range
%model is run on normal chamber (loss of amino acids to flow channel)
%
% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 12.6.2018
% Last update: 2018.11.18 updated to new parameters

% load default settings
settings = SteadyState_2D_SettingsRevision;

% load experimental spatial arrangements
load('experimentalSpatialArrangements.mat')

%SET TARGET interactionrange
rangeToAnalyze = [nan 1:0.5:30];

%preallocate memory
numRange = length(rangeToAnalyze);
numPos = size(gridCellTypeStack, 3);

muReal = nan(numPos,numRange);
muRealDT = nan(numPos,numRange);
muRealDP = nan(numPos,numRange);

% SET time points to analyse
for rr = 1:numRange
    locSet = settings;
    currRange = rangeToAnalyze(rr);
    if ~isnan(currRange)
        %set desired uptake rates
        [ru,delta_u] = find_ru_toUse(settings,currRange,currRange,false);
        locSet.ru = ru;
        locSet.delta_u = delta_u;
    end
    
    parfor pp = 1:numPos
        %get current chamber
        locSet2 = locSet;
        currChamber = squeeze(gridCellTypeStack(:,:,pp));
        
        %initialize grid        
        locSet2.gridScaling = locSet2.gridScalingBase;
        [initialCondition] = SteadyState_2D_InitGrid_2018(locSet2,'ProvidedGrid',currChamber);
        
        %SOLVE INITIAL STEADY STATE, use grid refinement until solution converges
        [output,~,~,~] = SteadyState_2D_RefineGrid_2018(locSet2,initialCondition);
        muGrid = output.mu; %matrix with growth rates for each cell
        typeGrid = output.gridCellType;
        
        %extract fraction and average growth
        muReal(pp,rr) = mean(muGrid(:));
        %split growth by type
        muRealDT(pp,rr) = mean(muGrid(typeGrid == 0));
        muRealDP(pp,rr) = mean(muGrid(typeGrid == 1));
    end
end

% calculate growth rate relative to that at real interaction range 
rangeVec = rangeToAnalyze(2:end);

muRealRel = muReal(:,2:end)./(muReal(:,1)*ones(1,length(rangeVec)));
muRealDTRel = muRealDT(:,2:end)./(muRealDT(:,1)*ones(1,length(rangeVec)));
muRealDPRel =    muRealDP(:,2:end)./(   muRealDP(:,1)*ones(1,length(rangeVec)));

% calculate mean relative growth as function of range
muRealRel_mean = mean(muRealRel);
muRealDTRel_mean = mean(muRealDTRel);
muRealDPRel_mean = mean(muRealDPRel);

%%
save('dataFigS5.mat','rangeVec','muRealRel_mean','muRealDTRel_mean','muRealDPRel_mean', 'settings');