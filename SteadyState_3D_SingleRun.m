% Script to run single simulation of 2D model of amino acid exchange
% Results are plotted
% Use code for testing and graph making
% Default settings are used unless relevant lines are uncommented and changed
%
% type 0 produces pro, growth limited by try
% type 1 produces try, growth limited by pro
% Boundary conditions: no flux on left, right, and top wall, [E] = 0 on bottom wall
%
% Solved with iterative finite difference scheme using successive over-relaxation (SOR) method
%
% Written by Simon van Vliet[1] & Alma Dal Co[2]
% [1] UBC Vancouver, [2] Harvard University
%
% Initial development: 06.02.2020
% Last update: 06.02.2020

%% Load default settings
settings = SteadyState_3D_Settings;

%% SET Initial grid type
initialGridSetting = 'SplitWorld';

%uncomment any line below to overwrite default settings

%% SET Initial grid settings
% settings.initFracType1 = 0.5; %intial fraction of type 1 in random arrangement
% settings.randNumFeed = 100;


settings.gridSize                =  [15, 15, 15]; %[Width (East-West), Depth (North-South), Height (Top-Bottom)]
settings.boundaryType            =  [0, 0, 1, 0, 0, 1]; %Set boundary conditions [North, East, South, West, Top, Bottom]
% 0 is closed boundary (zero-flux) / % 1 is open boundary (zero concentration)


%% SET  model parameters
% settings.Iconst1 = 100; %Concentration of produced amino-acid
% settings.Iconst2 = 100; %Concentration of produced amino-acid
% 
% settings.rho = 0.5; %Density
% settings.D0 = 2.74E6; %Diffusion constant in empty space
% settings.cellSpacing = 1.4; %Average cell spacing, used to rescale D0
% 
% settings.ru = 2.0E4;
% settings.rl = 2.9E-2; 
% 
% settings.delta_u = 16; %ru2/ru1  =  delta_u
% settings.delta_l = 1.5; %rl2/rl1  =  delta_u
% settings.delta_D = 0.75; %D2/D1  =  delta_u

%% SET grid properties
% settings.gridSizeCells = 40; %size of grid in trems of cells (1x1um blocks)
% settings.gridScalingBase = 4; %scale grid by this factor to make diffusion process converge
% settings.gridScaleFactor = 2; %keep at 2 (set factor at which grid is refined)

%% SET properties of run
% settings.DEBUG = 0;    %plot result at end of iterations
% settings.DEBUG_Extensive = 0; %plot results during iterations

%% SET properties SOR process
settings.tolerance = 1e-3; %the max relative difference between previous and current solution should be less than tolerance for each grid site
settings.muTolerance = 1e-2; %grid spacing is decreased untill mu profile changes by less than muTolerance (absolute difference)
%settings.omega = 1.9; %hand picked omega

%NOTE: omega (between 0-2) sets relaxation of solution
%Values omega>1 are used to speed up convergence of a slow-converging process
%Values omega<1 are  used to help establish convergence of a diverging iterative process or speed up the convergence of an overshooting process.
%Use a value as large as possible without blowing up solution
%omega = 2/(1+sin(pi/numGridPoint1D^2)); %optimal omega for Poisson process

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Inform user about effect of density
D = (settings.D0/(settings.cellSpacing)^2)*(1-settings.rho)./(1+settings.rho/2); %effective diffusion constant
alpha = settings.rho/(1-settings.rho);
fprintf('Effective D/D0 = %.3g\nEffective (D/alpha)/D0  =  %.3g\n\n',D/settings.D0,(D/alpha)/settings.D0)

%% initialize grid
settings.gridScaling = settings.gridScalingBase;
[initialCondition] = SteadyState_3D_InitGrid(settings,initialGridSetting);

%% SOLVE PROBLEM, use grid refinement until solution converges
[output,muAsFunctionOfGridSize,finalGridScaling] = SteadyState_3D_RefineGrid(settings,initialCondition);

figure
zToPlot = [1 4 8 12 15];
for zz=1:length(zToPlot)
nC = length(zToPlot);
subplot(2,nC,zz)
imagesc(output.gridCellType(:,:,zToPlot(zz)),[0 1])
title(['z=',num2str(zToPlot(zz))])


maxMu = max(max(output.mu(:,:,zToPlot(zz))));
maxMu = ceil(maxMu/0.01)*0.01;

subplot(2,nC,zz+nC)
imagesc(output.mu(:,:,zToPlot(zz)), [0, maxMu])
colorbar('SouthOutside')
end

