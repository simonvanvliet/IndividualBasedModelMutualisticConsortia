function output=SteadyState_2D_SOR_Solver_ClosedBoundary(settings,input)
% Core solver, called from all other codes that solve 2D steady state problem
% Calculates steady state solution for 2D model of amino acid exchange
% This is the main handler, the actual computation is done by SteadyState_2D_SOR_Solver_2018_CORE
% This last function also has a c++ implementation for increased performance
%% settings: model parameters
%% input: initial guess of solution
%% output: steady state solution,
%
% two cell types:
%   type 0 produces AA1, growth limited by AA2
%   type 1 produces AA2, growth limited by AA1
%   type 0 produces pro, growth limited by try: Delta try on left
%   type 1 produces try, growth limited by pro: Delta pro on right
% internal concentration of produced AA is set to Iconst
% AA uptake is linear with [E], leakage is passive diffusion
% uptake, leakage, and diffusion rates can be assymetric between AA
% effective diffusion constant = (1-p)/(1+p/2), where p is density
% time scaled with growth rate (1h doubling time)
% space scaled with cell size (settings.cellSpacing um)
% concentrations scaled with Km of growth for each AA
%
% Boundary conditions: no flux on left, right, and top wall, [E]=0 on bottom wall
%
% Solved with iterative finite difference scheme using successive over-relaxation (SOR) method
%
% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 10.5.2018
% Last update: 10.5.2018


%% get parameters model
Iconst1=settings.Iconst1; %COncentration of produced amino-acid
Iconst2=settings.Iconst2; %COncentration of produced amino-acid

D=(settings.D0/(settings.cellSpacing)^2)*(1-settings.rho)./(1+settings.rho/2); %effective diffusion constant
alpha=settings.rho/(1-settings.rho);

delta_u=settings.delta_u; %ru2/ru1 = delta_u
delta_l=settings.delta_l; %rl2/rl1 = delta_u
delta_D=settings.delta_D; %D2/D1 = delta_u

ru=settings.ru; %uptake rate
rl=settings.rl; %leakage rate

%% get grid properties
gridSizeCells=settings.gridSizeCells; %size of grid in terms of cells (1x1um blocks)
gridScaling=settings.gridScaling; %scale grid by this factor to make diffusion process converge
numGridPoint1D=gridSizeCells*gridScaling;
numGridPoint1DExtended=numGridPoint1D+2;
dx=1/gridScaling; % grid spacing
expectedGridSizeFine=[1 1]*gridSizeCells*gridScaling;
expectedGridSizeCourse=[1 1]*gridSizeCells;

%% get properties SOR process
tolerance=settings.tolerance; %the max relative difference between previous and current solution should be less than tolerance for each grid site
omega=settings.omega; %hand picked omega
%NOTE: omega (between 0-2) sets relaxation of solution
%Values omega>1 are used to speed up convergence of a slow-converging process
%Values omega<1 are  used to help establish convergence of a diverging iterative process or speed up the convergence of an overshooting process.
%Use a value as large as possible without blowing up solution
%omega=2/(1+sin(pi/numGridPoint1D^2)); %optimal omega for Poisson process


%% calculate parameter relations
ru1=ru / sqrt(delta_u);
ru2=ru * sqrt(delta_u);
rl1=rl / sqrt(delta_l);
rl2=rl * sqrt(delta_l);
D1=D / sqrt(delta_D);
D2=D * sqrt(delta_D);


%% Define production functions
% *(1-type): selects type 1, kills type 2
% *(type):   selects type 2, kills type 1
IofE=@(E,ru,rl,D)       (E*(ru+rl)   - rl + sqrt( (ru+rl)^2*E.^2 + 2*(rl+2)*(ru+rl)*E + rl^2 )) / (2*(1+rl));
%FofE1=@(E,ru,rl,D,type)  alpha*E*(ru+rl)/D -          alpha*Iconst1*(1-type)*rl/D - alpha*IofE(E,ru,rl,D).*type*rl/D;
%FofE2=@(E,ru,rl,D,type)  alpha*E*(ru+rl)/D - alpha*IofE(E,ru,rl,D).*(1-type)*rl/D -          alpha*Iconst2*type*rl/D;
muOfE=@(E1,E2,type)           (1-type).* IofE(E2,ru2,rl2,D2)./(1+IofE(E2,ru2,rl2,D2)) + (type).*IofE(E1,ru1,rl1,D1)./(1+IofE(E1,ru1,rl1,D1));


%% get input grid

gridE1=input.gridE1;
gridE2=input.gridE2;
gridCellType=input.gridCellType;
gridCellTypeScaled=input.gridCellTypeScaled;


%% check input grid
if sum(size(gridE1)==expectedGridSizeFine)~=2, error('E1 grid has wrong size'), end
if sum(size(gridE2)==expectedGridSizeFine)~=2, error('E2 grid has wrong size'), end
if sum(size(gridCellTypeScaled)==expectedGridSizeFine)~=2, disp(size(gridCellTypeScaled)), error('Cell Type Scaled grid has wrong size'),  end
if sum(size(gridCellType)==expectedGridSizeCourse)~=2, error('Cell type grid has wrong size'), end


%extend grid to allow for boundary conditions
exGridE1=zeros(numGridPoint1DExtended,numGridPoint1DExtended);
exGridE2=zeros(numGridPoint1DExtended,numGridPoint1DExtended);
exGridE1(2:end-1,2:end-1)=gridE1;
exGridE2(2:end-1,2:end-1)=gridE2;

extendedGridType=zeros(numGridPoint1DExtended,numGridPoint1DExtended);
extendedGridType(2:end-1,2:end-1)=gridCellTypeScaled;

%RUN SOR
%%
[exGridE1,exGridE2,numIt,errorCode]=SteadyState_2D_SOR_Solver_ClosedBoundary_CORE(...
    exGridE1,exGridE2,extendedGridType,int32(numGridPoint1D),dx,...
    ru1,ru2,rl1,rl2,D1,D2,Iconst1,Iconst2,alpha,...
    tolerance,omega);



%if errorCode==1, warning('Solution did not converge'); end
%%

gridE1=exGridE1(2:end-1,2:end-1);
gridE2=exGridE2(2:end-1,2:end-1);



%calculate output
gridE1_DownSampled=imresize(gridE1,1/gridScaling,'nearest');
gridE2_DownSampled=imresize(gridE2,1/gridScaling,'nearest');
mu=muOfE(gridE1_DownSampled,gridE2_DownSampled,gridCellType);

output.gridE1=gridE1;
output.gridE2=gridE2;
output.gridE1_DownSampled=gridE1_DownSampled;
output.gridE2_DownSampled=gridE2_DownSampled;
output.mu=mu;
output.gridCellType=gridCellType;
output.gridCellTypeScaled=gridCellTypeScaled;
output.settings=settings;

output.gridCellLength=input.gridCellLength; %pass trough cell length grid


I1=IofE(gridE1_DownSampled,ru1,rl1,D1);
I2=IofE(gridE2_DownSampled,ru2,rl2,D2);
output.I1=I1;
output.I2=I2;
muX=mean(mu(1:10,:));
output.muX=muX;

