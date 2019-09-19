function [output]=SteadyState_2D_InitGrid_2018(settings,initialGridSetting,varargin)
% Initializes grid for 2D steady state model of amino acid exchange
%% Output: initialized grid
%% Settings: model parameters
%% initialGridSetting: type of initial grid, Options are:
%    SplitWorld: left half=type1, right half=type2
%    LineWorld1: all type 0, except for center line which is type 1
%    LineWorld0: all type 1, except for center line which is type 0
%    Type0Island: all type 1, except for center point which is type 1
%    Type1Island: all type 0, except for center point which is type 1
%    Random: random assignment with initFracType1 assigned to type 1
%    RandomClustered: creates random clusters: start with random and create clusters by iteratively flipping neighboring
%    sides to same state.
%    ProvidedGrid: provide external grid in varargin
%
% type 0 produces pro, growth limited by try
% type 1 produces try, growth limited by pro
% Boundary conditions: no flux on left, right, and top wall, [E]=0 on bottom wall
%
% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 28.4.2018
% Last update: 28.4.2018

%% get model parameters
Iconst1=settings.Iconst1; %COncentration of produced amino-acid
Iconst2=settings.Iconst2; %COncentration of produced amino-acid

delta_u=settings.delta_u; %ru2/ru1 = delta_u
delta_l=settings.delta_l; %rl2/rl1 = delta_u

ru=settings.ru; %uptake rate
rl=settings.rl; %leakage rate
ru_1=ru / sqrt(delta_u);
ru_2=ru * sqrt(delta_u);
rl_1=rl / sqrt(delta_l);
rl_2=rl * sqrt(delta_l);



%% get grid properties
gridSizeCells=settings.gridSizeCells; %size of grid in terms of cells (1x1 blocks)
gridScaling=settings.gridScaling; %scale grid by this factor to make diffusion process converge

randNumFeed=settings.randNumFeedInitGrid;
initFracType1=settings.initFracType1;

%% init grid
gridCellType=zeros(gridSizeCells,gridSizeCells); %type: 0 produces AA1, 1 produces AA2
gridCellLength=ones(gridSizeCells,gridSizeCells);

%% setup initial grid
switch initialGridSetting
    case 'SplitWorld'
        midPoint=floor(gridSizeCells/2);
        gridCellType(:,midPoint+1:end)=1;
    case 'LineWorld1'
        midPoint=floor(gridSizeCells/2);
        gridCellType(:,midPoint:midPoint+1)=1;
    case 'LineWorld0'
        gridCellType=ones(gridSizeCells,gridSizeCells);
        midPoint=floor(gridSizeCells/2);
        gridCellType(:,midPoint:midPoint+1)=0;
    case 'Type0Island'
        gridCellType=ones(gridSizeCells,gridSizeCells);
        midPoint=floor(gridSizeCells/2);
        gridCellType(midPoint,midPoint)=0;        
    case 'Type1Island'
        gridCellType=zeros(gridSizeCells,gridSizeCells);
        midPoint=floor(gridSizeCells/2);
        gridCellType(midPoint,midPoint)=1; 
    case 'Random'
        rng(randNumFeed)
        randMatrix=rand(gridSizeCells,gridSizeCells);
        gridCellType(randMatrix<initFracType1)=0;
        gridCellType(randMatrix>=initFracType1)=1;
        gridCellLength=rand(gridSizeCells,gridSizeCells)+1;
    case 'RandomClustered'
        %create initiao random grid
        rng(randNumFeed)
        randMatrix=rand(gridSizeCells,gridSizeCells);
        gridCellType(randMatrix<initFracType1)=0;
        gridCellType(randMatrix>=initFracType1)=1;
        gridCellLength=rand(gridSizeCells,gridSizeCells)+1;
        bias=settings.bias;
        
        if settings.numReplacementInitGrid>0
            %perfrom settings.numReplacementInitGrid rounds of replacement where each grid site is visisted   
            numIt=ceil(settings.numReplacementInitGrid*(gridSizeCells-2)^2);
            
            pickRand=1;
            while pickRand %check if valid random number, exclude 0 and 1
                randNumVec=rand(numIt,3);
                if sum(randNumVec(:)==0)==0 && sum(randNumVec(:)==1)==0
                    pickRand=0;
                end
            end
            
            %select random focal cell, select random neighbor and replace neighbor with type of focal cell
            %bias can be used to bias formation of clusters in direction towards chamber opening to create stripes
            for nn=1:numIt
                rowCellToDevide=ceil(randNumVec(nn,1)*(gridSizeCells-2))+1;
                colCellToDevide=ceil(randNumVec(nn,2)*(gridSizeCells-2))+1;
                
                if randNumVec(nn,3)    <1/4+1/4*bias
                    offspringSite='t';
                elseif randNumVec(nn,3)<2/4+2/4*bias
                    offspringSite='b';
                elseif randNumVec(nn,3)<3/4+1/4*bias
                    offspringSite='b';
                else
                    offspringSite='l';
                end
                
                offSpringRow=rowCellToDevide;
                offSpringCol=colCellToDevide;
                
                if offspringSite=='t', offSpringRow=offSpringRow+1; end
                if offspringSite=='b', offSpringRow=offSpringRow-1; end
                if offspringSite=='r', offSpringCol=offSpringCol+1; end
                if offspringSite=='l', offSpringCol=offSpringCol-1; end
                
                gridCellType(offSpringRow,offSpringCol)=gridCellType(rowCellToDevide,colCellToDevide);
            end
        end
        
    case 'ProvidedGrid'
        %check for input grid validity
        if isempty(varargin), error('no input grid provided'); 
        else, gridIn=varargin{1}; end
        if ~ismatrix(gridIn), error('input is not 2D matrix'); end
        if sum(size(gridIn)==[gridSizeCells gridSizeCells])~=2, error('input is of wrong size'); end
        if (sum(gridIn(:)==0)+sum(gridIn(:)==1))~=gridSizeCells^2, error('input contains invalid numbers'); end
        
        gridCellType=gridIn;
end

%% Guess initial solution
%scale type grid up to full grid
gridCellTypeScaled=round(imresize(gridCellType,gridScaling,'nearest'));

%set initial E values
%in producing regions, set [E] to expected homogenous steady state value Iconst*rl_1/ru_1
%in non-producing regions, set [E] to expected homogenous steady state value devided by scaleFactorE
scaleFactorE=100; %guess for difference in [E] between producing and non producing regions
E1Init=(1-gridCellTypeScaled)*Iconst1*rl_1/ru_1 +     gridCellTypeScaled*Iconst1*rl_1/(ru_1*scaleFactorE);
E2Init=    gridCellTypeScaled*Iconst2*rl_2/ru_2 + (1-gridCellTypeScaled)*Iconst2*rl_2/(ru_2*scaleFactorE);


%store output
output.gridE1=E1Init;
output.gridE2=E2Init;
output.gridCellType=gridCellType;
output.gridCellTypeScaled=gridCellTypeScaled;
output.gridCellLength=gridCellLength;
output.settings=settings;

