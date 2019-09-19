function gridCellTypeStack=SteadyState_2D_Calc_CalibrationImagesRealData(settings,numChambers)
%creates 3D array with stack of cell type arrangements based on Real data
%INPUT: settings, model settings
%INPUT: numChambers, number of chambers to create
%
%OUTPUT: 3D array with stack of artificial cell type arrangements
%
%type 0 is Dtry
%type 1 is Dpro
%
% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 11.6.2018
% Last update: 11.6.2018

%SET SEGMENT SETTING
DProSegID=2; %what number does dPro cell have in segmented image 
DTrpSegID=3; %what number does dTrp cell have in segmented image

%%SET how segemented image is made into a square
squareGridMode='copy'; %copy or crop
%grid needs to be square, segmented image can be cropped (removing left and right edge)
% or can be extended by filling rows without info by copying last observed rows

%SET DEBUG SETTING
DEBUG=0;

%Init output
gridCellTypeStack=nan(settings.gridSizeCells,settings.gridSizeCells,numChambers);

%SET vanellus foder  %EDIT ALMA
VANELLUS_FOLDER = [ '~/Dropbox/microscope_analysis/STABILIZED', filesep];
%experiment list
experimentName_vect={
    '2016-09-30_part1',
    '2016-10-15_part1',
    '2017-09-29_part1_part2'
    } ;

%SET experiment to analyse
nExp=1;
%SET positions to analyse
ALL_POSITIONS=1; %analyse ALL_POSITIONS (loads experiemnt and this is is slow - don't reload if not needed)
positions=1; %analyse subset of position
%SET frames to analyse
frameToAnalyse=100;
    
%get all positions in experiment
if ALL_POSITIONS
    experiment=VExperiment([VANELLUS_FOLDER experimentName_vect{nExp}]);
    %positions=experiment_track.positionList;
    positions=experiment.positionList;
end

if numChambers>length(positions), warning('too few images passed'); end


%get grids
for ii=1:numChambers
    %% LOAD SEGMENTED IMAGE
    %get segmented image
    reg=VRegion([VANELLUS_FOLDER experimentName_vect{nExp} filesep positions{ii} '/reg']);
    segImage=reg.segmentations.getData(frameToAnalyse);
    
    %% Process segmented image to create typeGrid
    typeGrid=processSegmentedImage(settings,segImage,squareGridMode,DProSegID,DTrpSegID);
    
    %% Store grid
    gridCellTypeStack(:,:,ii)=typeGrid;
    
    if DEBUG
        figure(3091)
        subplot(1,2,1)
        imagesc(segImage)
        title(num2str(ii))
        
        subplot(1,2,2)
        imagesc(typeGrid)
        %colormap([1 0 0;0 1 0;0 0 1; 0 0 0])
        
        waitforbuttonpress
    end
end

end


function typeGrid=processSegmentedImage(settings,segImage,squareGridMode,DProSegID,DTrpSegID)

sizeSeg=size(segImage);

%first make sure that grid is square
switch squareGridMode
    case 'copy'
        if sizeSeg(1)<sizeSeg(2) %copy last rows
            extendedSeg=nan(sizeSeg(2),sizeSeg(2));
            extendedSeg(1:sizeSeg(1),:)=segImage;
            numExtendRow=sizeSeg(2)-sizeSeg(1);
            extendedSeg(sizeSeg(1)+1:end,:)=segImage(end-numExtendRow+1:end,:);
            segImage=extendedSeg;
        elseif sizeSeg(1)>sizeSeg(2) %
            error('chamber is higher than it is wide, I cannot handle this');
        end
    case 'crop'
        if sizeSeg(1)<sizeSeg(2) %crop away columns at edge
            numColToCrop=sizeSeg(2)-sizeSeg(1);
            numCropLeft=floor(numColToCrop/2);
            numCropRight=numColToCrop-numCropLeft;
            segImage=segImage(sizeSeg(1),(numCropLeft+1):(end-numCropRight));
        elseif sizeSeg(1)>sizeSeg(2) %
            error('chamber is higher than it is wide, I cannot handle this');
        end
end

%extract cell types for independent scaling
DProCells=segImage==DProSegID;
DTrpCells=segImage==DTrpSegID;

%rescale Grids
DProCells=imresize(double(DProCells),[settings.gridSizeCells settings.gridSizeCells]);
DTrpCells=imresize(double(DTrpCells),[settings.gridSizeCells settings.gridSizeCells]);

%initialize grid with randon numbers, converted to 0, 1 (this makes sure that every grid site is occupied
%in the  event that after rescaling neither DPro or Dtrp is present or when both are present in same number
typeGrid=round(rand(settings.gridSizeCells,settings.gridSizeCells));

%assign cell types to grid
typeGrid(DProCells>DTrpCells)=1; %if more DPro than DTrp assign DTrp
typeGrid(DTrpCells>DProCells)=0; %if more DTrp than DPro assign DTrp
%if DTrpCells==DProCells random initialization will insure that random cell type is assigned


end


