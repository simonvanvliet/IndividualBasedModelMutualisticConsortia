
%This code calculates interaction range by applying model to measured spatial arrangement 
%Cell growth rates are predicted for each cell and the correlation analysis is done

% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 12.6.2018
% Last update: 2018.11.18 updated to new parameters

%% SETTINGS
% SET DEBUG
DEBUG=0; %(turns on debug for subfunction that calcs interaction range and growth range)
RECOMPUTE=1; %run compuattion again?
RECREATE_IMAGESTACK=0; %recreate spatial real data [note: requires acccess to additional datafiles]?
SAVE_FILE=1;

% load default settings
settings=SteadyState_2D_SettingsRevision;

% SET CALIBRATION OPTIONS
numChambers=22; %number of chambers to analyze. With default settings 400 cell per chamer are used
radiusVec=1:0.5:20; %radia (in cell widths) at which neighborhood is evaluated
edgeToIgnore=10; %number of grid sites (cells) at edge to exclude from analysis
splitWorldGridMultiplier=1; %keep to one

%SET PLOT options
PLOT_REGRESSION=1; %plot regression line;
maxFracToFitDP=0.5; %max frac to fit
maxFracToFitDT=0.5; %max frac to fit
muInterval=100; %use to create nice axis, axis will be rounded to 1/muInterval


%% %%% START OF CODE %%%%%%
% Load dataset
if RECREATE_IMAGESTACK 
    fprintf('recreate image stack')
    gridCellTypeStack=SteadyState_2D_Calc_CalibrationImagesRealData(settings,numChambers);
else
    load('experimentalSpatialArrangements.mat')    
end
if RECOMPUTE
    %Compute interaction and growth range
    functionOutput=SteadyState_2D_Calc_InteractionGrowthRange(settings,gridCellTypeStack,edgeToIgnore,radiusVec,DEBUG,splitWorldGridMultiplier);
end

%extract data
RhoSqTrp = functionOutput.rhoDTAtRadius;
RhoSqPro = functionOutput.rhoDPAtRadius;
fractionOtherDPro = functionOutput.fractionOtherDPro;
muDPro = functionOutput.muDPro;
fractionOtherDTrp = functionOutput.fractionOtherDTrp;
muDTrp = functionOutput.muDTrp;
muDProInH = muDPro*settings.mu_wt;
muDTrpInH = muDTrp*settings.mu_wt;

maxTrp = functionOutput.maxRhoDT;
interactionRangeTrp = functionOutput.interactionRangeDT;

maxPro = functionOutput.maxRhoDP;
interactionRangePro = functionOutput.interactionRangeDP;

relRange = interactionRangePro / interactionRangeTrp;

%convert to um by multiplying by grid size
interactionRangeTrpUM = interactionRangeTrp*settings.cellSpacing;
interactionRangeProUM = interactionRangePro*settings.cellSpacing;
relRangeUM = interactionRangeProUM / interactionRangeTrpUM;

fprintf('interaction range in mu (dist from edge) DPro=%.3g, DTrp=%.3g, DPro/Dtrp=%.3g\n',...
    interactionRangeProUM,interactionRangeTrpUM,relRangeUM);

%fit growth rate data
toFitDP=fractionOtherDPro<maxFracToFitDP;
toFitDT=fractionOtherDTrp<maxFracToFitDT;

[~,~,slopeDProCurr,offsetDProCurr]=fitLinRegressionUltraFastV2(fractionOtherDPro(toFitDP),muDPro(toFitDP));
[~,~,slopeDTrpCurr,offsetDTrpCurr]=fitLinRegressionUltraFastV2(fractionOtherDTrp(toFitDT),muDTrp(toFitDT));

fracToFitDPro=0:0.05:maxFracToFitDP;
fracToFitDTrp=0:0.05:maxFracToFitDT;

fittedDPro=fracToFitDPro*slopeDProCurr+offsetDProCurr;
fittedDTrp=fracToFitDTrp*slopeDTrpCurr+offsetDTrpCurr;


if SAVE_FILE
    filename         = 'dataFig3d.mat';
    fractionVec      = {fractionOtherDPro,fractionOtherDTrp};
    growthVec        = {muDProInH, muDTrpInH};
    
    %%BIN Model data
    binSize=0.1;
    binLEdge                = 0:binSize:1-binSize;
    binREdge                = binSize:binSize:1;
    binCenter               = binSize/2:binSize:1;

    for tt=1:2
        binnedMu            = nan(1,length(binLEdge));
        fracTemp            = fractionVec{tt};
        muTemp              = growthVec{tt};
        for bb=1:length(binLEdge)
            inBin           = fracTemp>binLEdge(bb) & ...
                fracTemp<binREdge(bb);
            muInBin         = muTemp(inBin);
            binnedMu(bb)    = nanmedian(muInBin);
        end
        x_binned{tt} = binCenter;
        y_binned{tt} = binnedMu;
    end
    
    x_regressionline = {fracToFitDPro, fracToFitDTrp};
    y_regressionline = {fittedDPro, fittedDTrp};
    rangeVec         = [interactionRangePro, interactionRangeTrp];
    maxCorrVec       = [maxPro, maxTrp];
    orderOfTypes     = {'dpro', 'dtrp'};
    save(filename, 'fractionVec' , 'growthVec', 'x_binned', 'y_binned',...
        'x_regressionline', 'y_regressionline', 'rangeVec', 'maxCorrVec', 'orderOfTypes', 'settings');
    
    filename2         = 'dataFig3c.mat';
    correlation.roTrp = sqrt(RhoSqTrp);
    correlation.roPro = sqrt(RhoSqPro);
    correlation.range = radiusVec;
    correlation.IRPro = interactionRangeProUM;
    correlation.IRTrp = interactionRangeTrpUM;
    save(filename2,'correlation', 'settings');
end





