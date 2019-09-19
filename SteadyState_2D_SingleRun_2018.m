% Script to run single simulation of 2D model of amino acid exchange
% Results are plotted
% Use code for testing and graph making
% Default settings are used unless relevant lines are uncommented and changed
%
% type 0 produces pro, growth limited by try
% type 1 produces try, growth limited by pro
% Boundary conditions: no flux on left, right, and top wall, [E]=0 on bottom wall
%
% Solved with iterative finite difference scheme using successive over-relaxation (SOR) method
%
% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 28.4.2018
% Last update: 28.4.2018
    
%% Load default settings
settings=SteadyState_2D_SettingsRevision;

%% SET Initial grid type
initialGridSetting='SplitWorld';

%uncomment any line below to overwrite default settings

%% SET Initial grid settings
% settings.initFracType1=0.5; %intial fraction of type 1 in random arrangement
% settings.randNumFeed=100;

%% SET  model parameters
% settings.Iconst1=100; %Concentration of produced amino-acid
% settings.Iconst2=100; %Concentration of produced amino-acid
% 
% settings.rho=0.5; %Density
% settings.D0=2.74E6; %Diffusion constant in empty space
% settings.cellSpacing=1.4; %Average cell spacing, used to rescale D0
% 
% settings.ru=2.0E4;
% settings.rl=2.9E-2; 
% 
% settings.delta_u=16; %ru2/ru1 = delta_u
% settings.delta_l=1.5; %rl2/rl1 = delta_u
% settings.delta_D=0.75; %D2/D1 = delta_u

%% SET grid properties
% settings.gridSizeCells=40; %size of grid in trems of cells (1x1um blocks)
% settings.gridScalingBase=4; %scale grid by this factor to make diffusion process converge
% settings.gridScaleFactor=2; %keep at 2 (set factor at which grid is refined)

%% SET properties of run
% settings.DEBUG=0;    %plot result at end of iterations
% settings.DEBUG_Extensive=0; %plot results during iterations

%% SET properties SOR process
% settings.tolerance=1e-3; %the max relative difference between previous and current solution should be less than tolerance for each grid site
% settings.muTolerance=1e-2; %grid spacing is decreased untill mu profile changes by less than muTolerance (absolute difference)
% settings.omega=1.9; %hand picked omega

%NOTE: omega (between 0-2) sets relaxation of solution
%Values omega>1 are used to speed up convergence of a slow-converging process
%Values omega<1 are  used to help establish convergence of a diverging iterative process or speed up the convergence of an overshooting process.
%Use a value as large as possible without blowing up solution
%omega=2/(1+sin(pi/numGridPoint1D^2)); %optimal omega for Poisson process

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Inform user about effect of density
D=(settings.D0/(settings.cellSpacing)^2)*(1-settings.rho)./(1+settings.rho/2); %effective diffusion constant
alpha=settings.rho/(1-settings.rho);
fprintf('Effective D/D0=%.3g\nEffective (D/alpha)/D0 = %.3g\n\n',D/settings.D0,(D/alpha)/settings.D0)

%% initialize grid
settings.gridScaling=settings.gridScalingBase;
[initialCondition]=SteadyState_2D_InitGrid_2018(settings,initialGridSetting);

%% SOLVE PROBLEM, use grid refinement until solution converges
[output,muAsFunctionOfGridSize,finalGridScaling]=SteadyState_2D_RefineGrid_2018(settings,initialCondition);

%% Plot growth profile
%characterize growth profile
[InterfaceGrowthCurr,TotalGrowthCurr,GrowthRangeCurr] = characterizeGrowthProfileSplitWorld(output.muX,settings);

%plot growth profile
figure(201)
hold off
titleName=sprintf('r_u=%.2g, r_l=%.2g',settings.ru,settings.rl);
plotGrowthCurveSplitWorld(output.muX,settings,titleName)

%% Plot growth as function of gridsize

figure(202)
hold off
names=fieldnames(muAsFunctionOfGridSize);
numRow=length(names);

for mm=1:length(names)
    subplot(3,numRow,mm)
    try
        imagesc(muAsFunctionOfGridSize.(names{mm}))
        caxis([0 1])
        title(names{mm})
        axis image
    catch
    end
    
    
    if mm>1
        subplot(3,numRow,mm+numRow)
        imagesc(abs(muAsFunctionOfGridSize.(names{mm})-muAsFunctionOfGridSize.(names{mm-1})))
        caxis([0 0.2])
        title(names{mm})
        axis image
    end
    
    subplot(3,1,3)
    hold on
    muX=muAsFunctionOfGridSize.(names{mm});
    muX=mean(muX(1:10,:));
    
    plot(1:settings.gridSizeCells,muX)
    if mm==length(names)
    legend(names)
    end
end
