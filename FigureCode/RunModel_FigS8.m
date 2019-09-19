%Calculate interaction range as function of realistic rl parameters
%Note: we checked that IR(pro) does not depends on r_l(trp) and vice versa so we can do independent scans

% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 18.8.2019
% Last update: 21.8.2019 updated to new parameters

%% SETTINGS

% SET DEBUG
DEBUG=0; %(turns on debug for subfunction that calcs interaction range and growth range)

% load default settings
settings = SteadyState_2D_SettingsRevision;

% SET CALIBRATION OPTIONS
radiusVec=1:0.5:20; %radia (in cell widths) at which neighborhood is evaluated
edgeToIgnore=10; %number of grid sites (cells) at edge to exclude from analysis
splitWorldGridMultiplier = 1;

%SET Rl range
rl_abs = logspace(-8,-2,37);
delta = [1 25 1/25 50 1/50];
nrl = length(rl_abs);
nd = length(delta);

%% %%% START OF CODE %%%%%%
% Load experimentally measured spatial arrangements
load('experimentalSpatialArrangements.mat')

%initialize output
IR_pro_mu = nan(nd,nrl);
IR_trp_mu = nan(nd,nrl);

wf = waitbar(0,'calculating IR');    
for rl = 1:nrl
    for dd = 1:nd
        %set current leakage settings
        locSet = settings;

        rl_curr = rl_abs(rl) * settings.tD_s;
        locSet.rl = rl_curr;
        locSet.delta_l = delta(dd);

        %calculate interaction range
        try 
            functionOutput = SteadyState_2D_Calc_InteractionGrowthRange(locSet,gridCellTypeStack,edgeToIgnore,radiusVec,DEBUG,splitWorldGridMultiplier);
            IR_t = functionOutput.interactionRangeDT * locSet.cellSpacing;
            IR_p = functionOutput.interactionRangeDP * locSet.cellSpacing;
        catch
            IR_t = nan;
            IR_p = nan;
        end
     
        IR_pro_mu(dd,rl) = IR_p;
        IR_trp_mu(dd,rl) = IR_t;
        
        percdone = ((rl-1)*nd + dd) / (nd*nrl);
        waitbar(percdone, wf)
    end
end

close(wf)

%% Store Output
modelOutput = struct;
modelOutput.IR_pro =  IR_pro_mu;
modelOutput.IR_trp =  IR_trp_mu;
modelOutput.rl_abs =  rl_abs;
modelOutput.delta =  delta;
modelOutput.settings =  settings;

save('dataFigS8.mat','modelOutput')



