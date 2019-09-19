%This code can be used to calibrate growth range with interaction range
%It changes expected interaction range by scanning paramter r_u
%It computes both interaction range and growth range and plots calibration curve
%It uses real data as basis for cell grid

% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 12.6.2018
% Last update: 19.6.2018 %added option to save file and changed parfor to for loop

%% SETTINGS
% SET DEBUG
DEBUG = 0; %(turns on debug for subfunction that calcs interaction range and growth range)
SAVE_FILE = 1; %save calibration to file
RECREATE_IMAGESTACK=0; %recreate spatial real data [note: requires acccess to additional datafiles]?
CALC_INT_RANGE = 1;

% load default settings
settings = SteadyState_2D_SettingsRevision;

%set range of uptake rates to scan
numScanPoints = 20;
ruRange = logspace(log10(2E3), log10(2E5), numScanPoints);

% SET DATA TYPE
dataType = 'real'; %artificial/real use real segmented images or generated patterns

% SET CALIBRATION OPTIONS
radiusVec = 1:0.5:20; %radia (in cell widths) at which neighborhood is evaluated
edgeToIgnore = 10; %number of grid sites (cells) at edge to exclude from analysis

% SET SCAN OPTIONS
%cell array, each row specifies : parameter name, scan range, default value
splitWorldGridMultiplier = 1; %increase split world grid size by this fraction to reduce boundarty effects
    

%% %%% START OF CODE %%%%%%

% Load dataset
% Load dataset
if RECREATE_IMAGESTACK
    fprintf('recreate image stack')
    gridCellTypeStack = SteadyState_2D_Calc_CalibrationImagesRealData(settings,numChambers);
else
    load('experimentalSpatialArrangements.mat')
end

if CALC_INT_RANGE    
    %initOutput
    growthRangePro = nan(numScanPoints, 1);
    growthRangeTrp = nan(numScanPoints, 1);
    
    interactionRangePro = nan(numScanPoints, 1);
    interactionRangeTrp = nan(numScanPoints, 1);
    
    RhoSqPro = cell(numScanPoints, 1);
    RhoSqTrp = cell(numScanPoints, 1);
    
    %%Calc Analytical Growth range
    Deff = (settings.D0/(settings.cellSpacing)^2)...
        *(1-settings.rho)/(1+settings.rho/2)....
        *(1-settings.rho)/settings.rho;
    
    ruP = ruRange./sqrt(settings.delta_u);
    ruT = ruRange.*sqrt(settings.delta_u);
    
    rlP = settings.rl/sqrt(settings.delta_l);
    rlT = settings.rl*sqrt(settings.delta_l);
    
    DP = Deff/sqrt(settings.delta_D);
    DT = Deff*sqrt(settings.delta_D);
    
    r0P  =  sqrt(DP./(ruP+rlP));
    r0T  =  sqrt(DT./(ruT+rlT));
    
    %predicted GR from simplified formula (assuming Ic>>1 and rl<<mu)
    [GRP, ~]  =  GR_analytical(r0P, settings.Iconst2, rlP);
    [GRT, ~]  =  GR_analytical(r0T, settings.Iconst1, rlT);
    
    predictedRangeTrp  =  GRT'*settings.cellSpacing;
    predictedRangePro  =  GRP'*settings.cellSpacing;
    
    
    for nn = 1:numScanPoints %scan uptake rates
        localsettings = settings;
        %assign variable parameter
        localsettings.ru = ruRange(nn);
        
        %Compute interaction and growth range
        functionOutput = SteadyState_2D_Calc_InteractionGrowthRange(localsettings,gridCellTypeStack,edgeToIgnore,radiusVec,DEBUG,splitWorldGridMultiplier);
        
        %store output
        growthRangePro(nn) = functionOutput.muProHM;
        growthRangeTrp(nn) = functionOutput.muTryHM;
        interactionRangePro(nn) = functionOutput.interactionRangeDP;
        interactionRangeTrp(nn) = functionOutput.interactionRangeDT;
        
        RhoSqPro{nn} = functionOutput.rhoDPAtRadius;
        RhoSqTrp{nn} = functionOutput.rhoDTAtRadius;        
        
        if DEBUG
            waitforbuttonpress
        end
    end
    
    
    if SAVE_FILE
        %create fileName and open file
        matFileName = 'dataFig4b.mat';
        dataFile     =  matfile(matFileName, 'Writable', true);
        %save to file
        dataFile.growthRangeTrp = growthRangeTrp*settings.cellSpacing;
        dataFile.interactionRangeTrp = interactionRangeTrp*settings.cellSpacing;
        dataFile.growthRangePro = growthRangePro*settings.cellSpacing;
        dataFile.interactionRangePro = interactionRangePro*settings.cellSpacing;
        dataFile.predictedRangeTrp = predictedRangeTrp*settings.cellSpacing;
        dataFile.predictedRangePro = predictedRangePro*settings.cellSpacing;
        dataFile.dataType = dataType;
        dataFile.settings = settings;
        dataFile.timestamp = now;
    end
    
end



