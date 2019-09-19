%% makeFig S7: growth of strains 
clear; close all; 

%% DATA SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileNames  = {...
    'dataFigS7.mat',...
    'dataFigS7Auxo',...
    };
    
YDataNames                   = { 
    'muWT' ; ...
    'muAll';...
    };
YMeanNames                   = { 
    'muWTMean' ; ...
    'muAllMean';...
};


% FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = struct;
%fg.folder                       = '/Users/dalcoalm/Dropbox/Alma Figures/Fig3a - correlation vs interaction range - camel plot/';
fg.filename                     = 'FigS7';
fg.save                         = 1;

%% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

myCOLORS;
dTcol                           = yellow*.8;
dPcol                           = purple;
wtCol                           = [0.5 0.5 0.5];
wtColmean                       = [0.15 0.15 0.15];


fg.LineStyle                    = {'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none'}; % '-' 'none'
fg.LineWidth                    = {2, 1, 2, 1,2, 1, 2, 1};
fg.Color                        = {wtCol, wtCol, wtCol, wtCol, dTcol, dPcol, dTcol, dPcol};
fg.Marker                       = {'o', 'o', 'o', 'o','s','s','d','d'}; % '0' 'none'
fg.MarkerSize                   = {5, 5,5,5, 5, 5, 5, 5}; % 6
fg.MarkerFaceColor              = {wtCol, wtCol, wtCol, wtCol, dTcol, dPcol, dTcol, dPcol}; % 'none'
fg.MarkerEdgeColor              = {'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none'}; % 'none'


fg.MeanLineStyle                    = {'-', '-', '-', '-', '-', '-', '-', '-'}; % '-' 'none'
fg.MeanLineWidth                    = {3, 3, 3, 3, 3, 3, 3, 3};
fg.MeanColor                        = {wtColmean, wtColmean, wtColmean, wtColmean, wtColmean, wtColmean, wtColmean, wtColmean};
fg.MeanMarker                       = {'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none'}; % '0' 'none'
fg.MeanMarkerSize                   = {5, 5, 5, 5, 5, 5, 5, 5}; % 6
fg.MeanMarkerFaceColor              = {wtCol, wtCol, wtCol, wtCol, dTcol, dPcol, dTcol, dPcol}; % 'none'
fg.MeanMarkerEdgeColor              = {'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none'}; % 'none'

fg.meanWidth                        = 0.3;
fg.randOffset                       = 0.2;

%% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.axes.width                   = 17; % width of axes in cm
fg.axes.height                  = 3.8; % height of axes in cm
fg.axes.offset                  = [0.9 0.9 0.4 0.2]; % offset between axis and figure in cm [bottom left top right]
fg.axes.lineWidth               = 1;

fg.axes.ylabel                  = 'growth rate 1/h';
fg.axes.xlabel                  = 'strain and media';
fg.axes.xlabel_offset           = [ 0.0  -0.1];
fg.axes.ylabel_offset           = [ -.1  0.0];

fg.axes.ylim                    = [0 1.8];
fg.axes.yticks                  = 0:0.6:1.8;

%% Load DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xScatter = {};
yScatter = {};
legendMat = {};

xMean = {};
yMean = {};

idx = 0;

for ii = 1:length(fileNames)
    load(fileNames{ii})
    currYData = data.(YDataNames{ii});
    currYDataMean = data.(YMeanNames{ii});
    numRep = size(currYData,1);
    numCond = size(currYData,2);
    
    for jj = 1:numCond
        idx = idx+1;

        randOff = (rand(numRep,1)*2-1)*fg.randOffset;
        xScatter{idx}   = ones(numRep,1)*idx + randOff;
        yScatter{idx}   = currYData(:,jj);
        xMean{idx}      = [idx-fg.meanWidth  idx+fg.meanWidth];
        yMean{idx}      = [currYDataMean(jj);currYDataMean(jj)];
        legendMat{idx}  = data.legend{jj};
    end
end

xVectorCombined = 1:idx;
fg.axes.xticks                  = xVectorCombined; %auto set based on data
fg.axes.xlim                    = [0 idx+1]; %auto set based on data


%% PLOT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFig                            = figure('MenuBar','none', 'Name', fg.filename, 'NumberTitle', 'off');

%plot scatter
for i = 1:length(xScatter)
        
    line(xScatter{i}, yScatter{i}, ...
        'LineStyle', fg.LineStyle{i}, ...
        'LineWidth', fg.LineWidth{i}, ...
        'Color', fg.Color{i}, ...
        'Marker', fg.Marker{i}, ...
        'MarkerSize', fg.MarkerSize{i}, ...
        'MarkerFaceColor', fg.MarkerFaceColor{i}, ...
        'MarkerEdgeColor', fg.MarkerEdgeColor{i} );
    hold on
end


%plot mean
for i = 1:length(xScatter)
        
    line(xMean{i}, yMean{i}, ...
        'LineStyle', fg.MeanLineStyle{i}, ...
        'LineWidth', fg.MeanLineWidth{i}, ...
        'Color', fg.MeanColor{i}, ...
        'Marker', fg.MeanMarker{i}, ...
        'MarkerSize', fg.MeanMarkerSize{i}, ...
        'MarkerFaceColor', fg.MeanMarkerFaceColor{i}, ...
        'MarkerEdgeColor', fg.MeanMarkerEdgeColor{i} );
    hold on
end

%% ADJUST FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.figureWidth                  = fg.axes.width+fg.axes.offset(2)+fg.axes.offset(4);
fg.figureHeight                 = fg.axes.height+fg.axes.offset(1)+fg.axes.offset(3);
hFig.Units                      = 'centimeter';
hFig.Position                   = [1 1 fg.figureWidth fg.figureHeight];

hFig.PaperUnits                 = 'centimeters';
hFig.PaperSize                  = [fg.figureWidth fg.figureHeight];
% hFig.Renderer                   = 'Painters'; % for saving alpha (patches) as pdf

hAx                             = hFig.Children;
hAx.Units                       = 'centimeter';
hAx.Box                         = 'off';
hAx.LineWidth                   = fg.axes.lineWidth;
hAx.Position                    = [fg.axes.offset(2) fg.axes.offset(1) fg.axes.width fg.axes.height];
hAx.XLim                        = fg.axes.xlim;
hAx.YLim                        = fg.axes.ylim;
hAx.YScale                      = 'linear';
hAx.XTick                       = fg.axes.xticks;
hAx.XTickLabel                  = legendMat;

hAx.YTick                       = fg.axes.yticks;
hAx.TickLength                  = [0.015 0.015];
hAx.XMinorTick                  = 'off';
hAx.YMinorTick                  = 'off';
hAx.FontName                    = 'Arial';
hAx.FontWeight                  = 'normal';
hAx.FontSize                    = 7;

hAx.XLabel.String               = fg.axes.xlabel;
hAx.XLabel.Units                = 'centimeter';
hAx.XLabel.FontName             = 'Arial';
hAx.XLabel.FontWeight           = 'normal';
hAx.XLabel.FontSize             = 9;
hAx.XLabel.Position             = [fg.axes.xlabel_offset 0] + hAx.XLabel.Position;
hAx.YLabel.String               = fg.axes.ylabel;
hAx.YLabel.Units                = 'centimeter';
hAx.YLabel.FontName             = 'Arial';
hAx.YLabel.FontWeight           = 'normal';
hAx.YLabel.FontSize             = 9;
hAx.YLabel.Position             = [fg.axes.ylabel_offset 0] + hAx.YLabel.Position;


%% Do Stat
muValues = cell2mat(yScatter);
[p,tbl,stats] = anova1(muValues);
fprintf('Anova test p=%.2g',p);
disp(tbl)
% tukey-kramer correction for multiple comparison
mctable = multcompare(stats, 'CType', 'tukey-kramer');

%% add significance groups
figure(hFig)
[SignificanceGroupsCellArray,significanceGroupsString] = ...
    findSignificanceGroupsMultiComp(stats,mctable);

numSigLetLoc = zeros(1,length(yMean)); %this vector keeps track of vertical displacement
sigLetters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p'};
startY = 1.75; %adjust to set height of first nr (in axis units)
deltaY = 0.1; %adjust to set offset between letters (in axis units)

for sigG = 1:length(SignificanceGroupsCellArray)
    groupsToPlot = SignificanceGroupsCellArray{sigG};
    
    %x-loc
    xtext = xVectorCombined(groupsToPlot);
    %y-loc
    minY = max(numSigLetLoc(groupsToPlot));
    ytext = ones(size(xtext)) * startY + deltaY * minY;
    
    text(xtext, ytext, sigLetters{sigG},...
        'FontName','Arial',...
        'FontSize',7,...
        'HorizontalAlignment','center')

    numSigLetLoc(groupsToPlot) = numSigLetLoc(groupsToPlot)+1;
end


%% SAVE FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if fg.save
    saveas( hFig, [fg.filename '.pdf']);
    disp([' * Saved figure in ' fg.filename '.pdf']);
end


