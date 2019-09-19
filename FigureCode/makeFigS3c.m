%% Make figure S3c
clear; close all; 

%% DATA SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = struct;
data.selection                    = [1 2]; ... [3 4]
data.filenames                    = { ...
    'dataFigS3.mat'; ...    
    };
data.XDataNames                   = { 
    'clusterSizeVec' ; ...
    'clusterSizeVec' ; ...
    };
data.YDataNames                   = { 
    'intRangeTrpum' ; ...
    'intRangeProum' ; ...
    };

% FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = struct;
fg.filename                     = 'FigS3c';
fg.save                         = 1;

%% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myCOLORS;
fg.Marker                       = {'s','o'}; % 'o' 'none'
fg.MarkerSize                   = {7, 6}; % 6
fg.MarkerEdgeColor              = {yellow*.8,purple}; % 'none'
fg.MarkerFaceAlpha              = {0};
fg.MarkerFaceColor              = {'none','none'};
fg.LineStyle                    = {'-', '-'}; % '-' 'none'
fg.LineWidth                    = {1, 1};
fg.Color                        = {yellow*.8,purple};

%% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.axes.width                   = 3.8; % width of axes in cm
fg.axes.height                  = 3.8; % height of axes in cm
fg.axes.offset                  = [1 1 0.4 0.4]; % offset between axis and figure in cm [bottom left top right]
fg.axes.lineWidth               = 1;

fg.axes.xlabel                  = 'patch size [a.u.]';
fg.axes.ylabel                  = 'interaction range [\mum]';
fg.axes.xlabel_offset           = [ 0.0  -0.1];
fg.axes.ylabel_offset           = [ -0.1  0.0];

fg.axes.xlim                    = [0 100];
fg.axes.ylim                    = [0 20];
fg.axes.xticks                  = [0:20:100];
fg.axes.yticks                  = [0:5:20];

%% LOAD DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load( data.filenames{1});
for i=data.selection
    data.Y{i}              = eval( data.YDataNames{data.selection(i)} );
    data.X{i}              = eval( data.XDataNames{data.selection(i)} ); ... * [-54:-54-1+numel(data.Y{i})] / 60;
end

%% PLOT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFig                            = figure('MenuBar','none', 'Name', fg.filename, 'NumberTitle', 'off');
idx=[2,6,7,8,9,10,11,12,13,14,15];
for i=data.selection
    h=line(data.X{i}(idx),data.Y{i}(idx),  ...
        'Marker', fg.Marker{i}, ...
        'MarkerSize', fg.MarkerSize{i}, ...
        'MarkerFaceColor', fg.MarkerFaceColor{i}, ...
        'LineStyle',  fg.LineStyle{i} , ...                  
        'LineWidth', fg.LineWidth{i},...
        'Color' , fg.Color{i});
    
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
hAx.Box                         = 'on';
hAx.LineWidth                   = fg.axes.lineWidth;
hAx.Position                    = [fg.axes.offset(2) fg.axes.offset(1) fg.axes.width fg.axes.height];
hAx.XLim                        = fg.axes.xlim;
hAx.YLim                        = fg.axes.ylim;
hAx.YScale                      = 'linear';
hAx.XTick                       = fg.axes.xticks;
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


%% SAVE FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if fg.save
    saveas( hFig, [fg.filename '.pdf']);
    disp([' * Saved figure in ' fg.filename '.pdf']);
end

