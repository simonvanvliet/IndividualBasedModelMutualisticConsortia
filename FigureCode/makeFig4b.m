%% makeFig4b
%clear; close all;

%% DATA SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = struct;

data.selection                    = [1 2];

data.filenames                    = {'dataFig4b.mat'};

data.XDataNames                   = { ...
    'predictedRangePro' ; ...
    'predictedRangeTrp' ; ...
    };

data.YDataNames                   = { ...
    'interactionRangePro' ; ...
    'interactionRangeTrp' ; ...
    };

%data.show                         = {[12:1:19],[1:2:19] };
data.show                         = {[8:1:19],[1:2:18] };

% FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = struct;
fg.filename                     = 'Fig4b';
fg.save                         = 1;

%% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myCOLORS;
dTcol                           = yellow*.8;
dPcol                           = purple;
fg.LineStyle                    = {'-','-'}; % '-' 'none'
fg.LineWidth                    = {1.5, 1.5};
fg.Color                        = {[0.0 0.0 0.0 0.5],[0.0 0.0 0.0 0.5]}; % 4th number is transparency
fg.Marker                       = {'o','s'}; % '0' 'none'
fg.MarkerSize                   = {6, 7}; % 6
fg.MarkerFaceColor              = {'none','none'}; % 'none'
fg.MarkerEdgeColor              = {dPcol,dTcol}; % 'none'

%% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.axes.width                   = 3.8; % width of axes in cm
fg.axes.height                  = 3.8; % height of axes in cm
fg.axes.offset                  = [1.3 1.3 0.6 1.]; % offset between axis and figure in cm [bottom left top right]
fg.axes.lineWidth               = 1;

fg.axes.xlabel                  = 'growth range [\mum]';
fg.axes.ylabel                  = 'interaction range [\mum]';
fg.axes.xlabel_offset           = [ 0.0  -0.1];
fg.axes.ylabel_offset           = [ -0.1  0.0];

fg.axes.xlim                    = [0 20];
fg.axes.ylim                    = [0 20];
fg.axes.xticks                  = [0:5:20];
fg.axes.yticks                  = [0:5:20];

%% LOAD DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load( data.filenames{1});
for i=data.selection
    data.Y{i}              = eval( data.YDataNames{data.selection(i)} );
    data.X{i}              = eval( data.XDataNames{data.selection(i)} ); ... * [-54:-54-1+numel(data.Y{i})] / 60;
    data.idx                      = data.show{i};
    data.idx( data.idx > numel(data.X{i}) ) = [];
    data.X{i}                     = data.X{i}(data.idx);
    data.Y{i}                     = data.Y{i}(data.idx); 

end


%% PLOT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFig                            = figure('MenuBar','none', 'Name', fg.filename, 'NumberTitle', 'off');

for i=data.selection
    line(   data.X{i}, data.Y{i}, ...
        'LineStyle', 'none', ...
        'Marker', fg.Marker{i}, ...
        'MarkerSize', fg.MarkerSize{i}, ...
        'MarkerFaceColor', fg.MarkerFaceColor{i}, ...
        'MarkerEdgeColor', fg.MarkerEdgeColor{i} );
    hold on;
    
    
   
end

dydx = nan(2,1);
offset = nan(2,1);

for i=data.selection
    %regression
    [dydx(i),offset(i)]=fitLinRegressionUltraFast(data.X{i},data.Y{i});
    
    line(   data.X{i}, offset(i)+dydx(i)*data.X{i}, ...
        'LineStyle', fg.LineStyle{i}, ...
        'LineWidth', fg.LineWidth{i}, ...
        'Color', fg.Color{i}, ...
        'Marker', 'none' );
    
    r = corr(data.X{i},data.Y{i}); 
    fprintf('slope = %.3g, offset = %.3g, r2= %.3g\n',dydx(i),offset(i),r^2)

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

%legend({sprintf('int. range = %.2f growth range%.2f',dydx(1),offset(1)),sprintf('int. range = %.2f growth range%.2f',dydx(2),offset(2))},'Location', 'none','Position' ,[.01 .3 1 1], 'FontSize', 5)
%legend('boxoff')
%% SAVE FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if fg.save
    saveas( hFig, [fg.filename '.pdf']);    
    disp([' * Saved figure in ' fg.filename '.pdf']);
end

fprintf('DPro int. range = %.2f * growth range + %.2f\n',dydx(1),offset(1))
fprintf('DTrp int. range = %.2f * growth range + %.2f\n',dydx(2),offset(2))
