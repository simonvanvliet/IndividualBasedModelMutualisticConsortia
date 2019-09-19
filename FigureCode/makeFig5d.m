%% makeFig5d
clear; close all; 

%% DATA SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = struct;
data.selection                    = [1 ];
data.filenames                    = { ...
                                    'dataFig5d.mat' ; ...
                                  };
data.YDataNames                   = { ...
                                    'muRand_mean' ; ...
                                    'muReal' ; ...
                                  };
                              
% FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = struct;
fg.filename                     = 'Fig5d';
fg.save                         = 1;

%% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.LineStyle                    = {'-', 'none'}; % '-' 'none'
fg.LineWidth                    = {1.5, 1.5}; 
fg.Color                        = {[0.1 0.1 0.1 .2]};
fg.Marker                       = {'.', '.'}; % 'o' 'none'
fg.MarkerSize                   = {11, 11}; % 6
fg.MarkerFaceColor              = {'none', 'none'}; % 'none'
fg.MarkerFaceAlpha              = {.8, .8};
fg.MarkerEdgeColor              = {[0 0.0 0.0], [.5 .5 .5]}; % 'none'

%% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.axes.width                   = 3.8; % width of axes in cm
fg.axes.height                  = 3.8; % height of axes in cm
fg.axes.offset                  = [1.1 1.1 0.2 0.2]; % offset between axis and figure in cm [bottom left top right]
fg.axes.lineWidth               = 1;

%fg.axes.xlabel                  = 'growth_{random} growth_{real} [1/h]';
%fg.axes.ylabel                  = 'number of communities';
fg.axes.xlabel                  = {'   \color{black}real   \color{gray}randomized'; '\color{black}arrangements'};
fg.axes.ylabel                  = 'growth rate [1/h]';
fg.axes.xlabel_offset           = [ 0.0  -0.1];
fg.axes.ylabel_offset           = [ -0.1  0.0];

%  fg.axes.xlim                    = [.7 1.3];
%  fg.axes.ylim                    = [0 10];
fg.axes.xlim                    = [.5 2.5];
fg.axes.ylim                    = [.15 .3];
fg.axes.xticks                  = [];
fg.axes.yticks                  = [.15:.05:.3];

%% LOAD DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = data.selection %1:numel(dt.selection)
    load(data.filenames{i});
    data.Y{i}                     = eval( data.YDataNames{i} ); %0.041 = micrometer per pixel
%     dt.X{i}                     = ones( size(dt.Y{i}) ) + 0.2*rand(1,numel(dt.Y{i})) - 0.2;
    %data.X{i}                     = ones( size(data.Y{i}) ) + [-0.1:0.04:0.26];
end


%% PLOT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFig                            = figure('MenuBar','none', 'Name', fg.filename, 'NumberTitle', 'off');

%histogram(muRand_mean(1,:,5)./muReal(1,:,5) ,6, 'Normalization', 'count' );
for i=1:22
muRealArray(i)=muReal(i);
muRandArray(i)=muRand_mean(i);
line( [1 2] , [muReal(i) muRand_mean(i)], ...
             'LineStyle', fg.LineStyle{1}, ...
            'LineWidth', fg.LineWidth{1}, ...
            'Color', fg.Color{1}, ...
            'Marker', fg.Marker{1}, ...
            'MarkerSize', fg.MarkerSize{1}, ...
            'MarkerFaceColor', fg.MarkerFaceColor{1}, ...
            'MarkerEdgeColor', fg.MarkerEdgeColor{1} );
hold on
plot(2, muRand_mean(i),...
            'Marker', fg.Marker{2}, ...
            'MarkerSize', fg.MarkerSize{1}, ...
            'MarkerFaceColor', fg.MarkerFaceColor{2}, ...
            'MarkerEdgeColor', fg.MarkerEdgeColor{2})
    
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

%% SHOW MEAN %%%%
[h,p]=ttest(muRealArray-muRandArray)