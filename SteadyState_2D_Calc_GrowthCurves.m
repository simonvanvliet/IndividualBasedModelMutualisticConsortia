function [muDTrp,fracDPForDTAtRadius,muDPro,fracDTForDPAtRadius]=...
    SteadyState_2D_Calc_GrowthCurves(muGrid,typeGrid,edge,radiusVec)
%
%Extracts for all cells growth rate and spatial arrangement
%INPUT: muGrid: grid of growth rates
%INPUT: typeGrid: grid of cell types
%INPUT: edge: number of pixels on edge of chamber where cells are excluded from analyis
%INPUT: radiusVec: vector of radia (in pixels) for which spatial arrangement is quantified
%
%Output: muDTrp/muDPro: vector of growth rates for each DTrp or Dpro cell
%Output: fracDPForDTAtRadius/fracDTForDPAtRadius: matrix #cell*#radia
%... each row gives vector of fraction of other type within neighborhood as function of radius 
%
%
% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 11.6.2018
% Last update: 11.6.2018

%SET DEBUG
DEBUG=0;

DTrpIndex=0; %type 0 is Dtry
DProIndex=1; %type 1 is Dpro

colormap('parula')

%init grid settings
gridSize=size(typeGrid);
yGrid=(1:gridSize(1))'*ones(1,gridSize(2));
xGrid=ones(gridSize(1),1)*(1:gridSize(2));
numInteriorPoints=(gridSize(1)-2*edge)*(gridSize(2)-2*edge);

numRadia=length(radiusVec);

%init output
muVec=nan(numInteriorPoints,1);
typeVec=nan(numInteriorPoints,1);
DProWithinRadius=nan(numInteriorPoints,numRadia);
DTrpWithinRadius=nan(numInteriorPoints,numRadia);

%loop over all interior grid points
currIndex=0;
for row=edge+1:gridSize(1)-edge
    for col=edge+1:gridSize(2)-edge
        
        currIndex=currIndex+1;

        %extract current type and growth rate
        currMu=muGrid(row,col);
        currType=typeGrid(row,col);
        
        muVec(currIndex)=currMu;
        typeVec(currIndex)=currType;
        
        %calculate distance to all other grid points
        currX=xGrid(row,col);
        currY=yGrid(row,col);
        rMat=sqrt((double(xGrid-currX)).^2+(double(yGrid-currY)).^2);
        
        %extract distances to cells of certain type
        rMatDTrp=rMat(typeGrid==DTrpIndex);
        rMatDPro=rMat(typeGrid==DProIndex);
        
        %scan radia and store data
        for rr=1:numRadia
            upperR=radiusVec(rr);
            DProWithinRadius(currIndex,rr)=sum(rMatDPro<=upperR);
            DTrpWithinRadius(currIndex,rr)=sum(rMatDTrp<=upperR);
        end
    end
end

%split data into cell types and calculate fraction for each radius
muDTrp=muVec(typeVec==DTrpIndex);
fracDPForDTAtRadius=DProWithinRadius(typeVec==DTrpIndex,:)./(DProWithinRadius(typeVec==DTrpIndex,:)+DTrpWithinRadius(typeVec==DTrpIndex,:));

muDPro=muVec(typeVec==DProIndex);
fracDTForDPAtRadius=DTrpWithinRadius(typeVec==DProIndex,:)./(DProWithinRadius(typeVec==DProIndex,:)+DTrpWithinRadius(typeVec==DProIndex,:));

%%
if DEBUG
    figure(501);
    ax1=subplot(1,2,1);
    imagesc(typeGrid)
    colormap(ax1,[1 0 0;0 1 0])
    axis image
    subplot(1,2,2);
    imagesc(muGrid)
    axis image
end

   