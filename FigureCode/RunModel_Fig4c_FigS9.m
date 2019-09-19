%Use code to scan parameter space of ru and rl for growth range
%
%Caluclates growth for single cell of type 1 in sea of type 0 and vice-versa
%i.e. of Delta Pro in sea if Delta Trp
% calculates growth range for split world Dtrp on left DPro on right)
% calculates interaction range
%
%scans through rl_pro and rl_trp values to check how growth rate and
%range depend on rl
%
%1D parameter scan, pro and trp are independent allowing for 1D scan

% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 11.6.2018
% Last update: 3.9.2018


% AA1=pro AA2=trp
% type 0 produces pro, growth limited by try
% type 1 produces try, growth limited by pro

%% Load default settings
settings=SteadyState_2D_SettingsRevision;


%% SET PROCESSING SETTINGS
DEBUG=0;
CALC=1; %recalculate?
SAVE_DATA=1;

%% SET parameters to scan
rlFullRange=logspace(-5,-1,21);
ruNormRange=logspace(-4,0,21);
duRange=1; 
dlRange=1; 

deltaD_heatmap=1;
delta_rl_heatmap=1;
delta_ru_heatmap=1;
axisStep=[5 5]; %sets axis intervals, should be on powers of 10,

%numScanPoint (last parameter of logspace) =axisStep*(FullLogValues-1)+1
%where FullLogValues is number of powers of 10 (i.e. logspace(-5,-3,x) has 3 FullLogValues)


%init loops
num_rl=length(rlFullRange);
num_ru=length(ruNormRange);
aggregatedOutcome=struct;

%init output
rlMat=nan(num_ru,num_rl);
ruMat=nan(num_ru,num_rl);

growthRangeDPro=nan(num_ru,num_rl);
growthRangeDTrp=nan(num_ru,num_rl);

for nRL=1:num_rl
    parfor nRU=1:num_ru
        localSettings=settings;
        
        %store current parameters
        localSettings.rl=rlFullRange(nRL);
        localSettings.ru=ruNormRange(nRU)*settings.D0/(settings.cellSpacing)^2;
        localSettings.delta_l=delta_rl_heatmap;
        localSettings.delta_u=delta_ru_heatmap;
        localSettings.delta_D=deltaD_heatmap;
        if CALC
            
            %% SOLVE split world problem
            localSettings.gridScaling=localSettings.gridScalingBase;
            [initialCondition]=SteadyState_2D_InitGrid_2018(localSettings,'SplitWorld');
            
            %solve steady state
            [output,~,~,~]=SteadyState_2D_RefineGrid_2018(localSettings,initialCondition);
            
            %calc growth range
            muX=mean(output.mu(10:20,:),1);
            [muTryHM, muProHM, intMuTry, intMuPro]=SteadyState_2D_Calc_GrowthRangeSplitWorld(muX);
            
            %store output
            growthRangeDPro(nRU,nRL)=muProHM;
            growthRangeDTrp(nRU,nRL)=muTryHM;
            
            rlMat(nRU,nRL)=localSettings.rl;
            ruMat(nRU,nRL)=localSettings.ru;
        end
    end
end

aggregatedOutcome.rlMat=rlMat;
aggregatedOutcome.ruMat=ruMat;

aggregatedOutcome.growthRangeDTrp=growthRangeDTrp;
aggregatedOutcome.growthRangeDPro=growthRangeDPro;
if SAVE_DATA
    save('dataFigS9.mat','aggregatedOutcome','-v7.3');
end




%% calculate real rates
ruPro=settings.ru/sqrt(settings.delta_u);
rlPro=settings.rl/sqrt(settings.delta_l);

ruTrp=settings.ru*sqrt(settings.delta_u);
rlTrp=settings.rl*sqrt(settings.delta_l);

DPro=settings.D0/sqrt(settings.delta_D)/(settings.cellSpacing)^2;
DTrp=settings.D0*sqrt(settings.delta_D)/(settings.cellSpacing)^2;

rlRange=log10(max(rlFullRange))-log10(min(rlFullRange));
ruRange=log10(max(ruNormRange))-log10(min(ruNormRange));

rlOffset=log10(min(rlFullRange));
ruOffset=log10(min(ruNormRange));

ruProNorm=(ruPro./DPro);
ruTrpNorm=(ruTrp./DTrp);
rlProNorm=(rlPro);
rlTrpNorm=(rlTrp);

ruRangeLog=[log10(min(ruNormRange)) log10(max(ruNormRange))];
rlRangeLog=[log10(min(rlFullRange)) log10(max(rlFullRange))];

%% calculate analytical range
Deff=(settings.D0/(settings.cellSpacing)^2)...
    *(1-settings.rho)/(1+settings.rho/2)....
    *(1-settings.rho)/settings.rho;

%calc range on grid of simulation
rlMat=aggregatedOutcome.rlMat;
ruMat=aggregatedOutcome.ruMat;

r0Mat = sqrt(Deff ./ ((ruMat + rlMat)));
[GRsimpleCourse,GRfullCourse] = GR_analytical(r0Mat, settings.Iconst1, rlMat);

%calc range at high resolution
rlFine=logspace(rlRangeLog(1),rlRangeLog(2),1000);
ruFine=logspace(ruRangeLog(1),ruRangeLog(2),1000)*settings.D0/(settings.cellSpacing)^2;

[rlFineGrid,ruFineGrid] = meshgrid(rlFine,ruFine);
r0FineMat = sqrt(Deff ./ ((ruFineGrid + rlFineGrid)));

[GRsimpleFine,GRfullFine] = GR_analytical(r0FineMat, settings.Iconst1, rlFineGrid);

%%
if SAVE_DATA
    %save calculated range (simplified and full equation)
    save('dataFig4c.mat','rlMat','ruMat','GRsimpleFine','GRfullFine' ,'GRsimpleCourse', '-v7.3');
end


