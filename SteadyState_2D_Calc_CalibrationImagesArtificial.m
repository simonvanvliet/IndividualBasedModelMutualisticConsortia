function gridCellTypeStack=SteadyState_2D_Calc_CalibrationImagesArtificial(settings,numChambers,clusterSize,rangeInitFracType1)
%creates 3D array with stack of artificial cell type arrangements
%INPUT: settings, model settings
%INPUT: numChambers, number of chambers to create
%INPUT: clusterSize, size of clusters to create
%
%OUTPUT: 3D array with stack of artificial cell type arrangements
%
% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 11.6.2018
% Last update: 11.6.2018


DEBUG=0;

%SET GRID SETTINGS
settings.initialGridSetting='RandomClustered';
settings.numReplacementInitGrid=clusterSize;
if nargin==3
    rangeInitFracType1=[0.25 0.75];% chambers are created by uniformly sampling this range for intial fraction of type 1 
end

fprintf('using intit freq between %.2g and %.2g',rangeInitFracType1(1),rangeInitFracType1(2));

%Init output
gridCellTypeStack=nan(settings.gridSizeCells,settings.gridSizeCells,numChambers);

initFracVec=linspace(rangeInitFracType1(1),rangeInitFracType1(2),numChambers);

greenC=[0,150,61]/256;
redC=[222,0,35]/256;
        
%Generate grids
for ii=1:numChambers
    goodGrid=false;
    settings.initFracType1=initFracVec(ii);
    settings.randNumFeedInitGrid=100*ii; %give each chamber different rand feed

    while ~goodGrid
        [initialCondition]=SteadyState_2D_InitGrid_2018(settings,settings.initialGridSetting);
        typeGrid=initialCondition.gridCellType;
        
        if sum(typeGrid(:)==0)>0 && sum(typeGrid(:)==1)>0 %check that both cell types are there
            goodGrid=true;
        end
    end
    
    gridCellTypeStack(:,:,ii)=typeGrid;
    
    if DEBUG
        figure(3091)
        imagesc(typeGrid)
        
        colormap([redC;greenC])
        
        waitforbuttonpress
    end
end

        
        
        
        