%% makeFig5e
close all; 

%% DATA SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = struct;
data.selection                    = [ 2 3];

data.filenames                    = { ...
                                    'dataFig5e.mat' ; ...
                                  };
data.XDataNames                   = { ...
                                    'rangeVec' ; ...
                                    'rangeVec' ; ...
                                    'rangeVec' ; ...
                                    };
data.YDataNames                   = { ...
                                    'muRealRel_mean' ; ...
                                    'muRealDTRel_mean'; ...
                                    'muRealDPRel_mean'; ...
                                    };

% FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = struct;
fg.filename                     = 'Fig5e';
fg.save                         = 1;

%% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myCOLORS;
dTcol                           = yellow*.8;
dPcol                           = purple;
fg.LineStyle                    = {'-','-','--'}; % '-' 'none'
fg.LineWidth                    = {1.5,1.5,1.5};
fg.Color                        = {[0.1 0.1 0.1 1],[dTcol 1],[dPcol 1]}; % 4th number is transparency
fg.Marker                       = {'none','none','none'}; % '0' 'none'
fg.MarkerSize                   = {4,4,4}; % 6
fg.MarkerFaceColor              = {'none','none','none'}; % 'none'
fg.MarkerEdgeColor              = {[0.6 0.1 0.1],[0.6 0.1 0.1],[0.6 0.1 0.1]}; % 'none'

%% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.axes.width                   = 3.8; % width of axes in cm
fg.axes.height                  = 3.8; % height of axes in cm
fg.axes.offset                  = [1.1 1.1 0.3 0.3]; % offset between axis and figure in cm [bottom left top right]
fg.axes.lineWidth               = 1;

fg.axes.xlabel                  = 'growth range [\mum]';
fg.axes.ylabel                  = 'relative growth rate';  
fg.axes.xlabel_offset           = [ 0.0 -0.1];
fg.axes.ylabel_offset           = [ -0.1  0.0];

fg.axes.xlim                    = [1 25];
fg.axes.ylim                    = [.75 1.5] ; ...[.55 1];
fg.axes.xticks                  = [0:5:25];
fg.axes.yticks                  = [0.75:.25:1.5]; ...[.6:.1:1];

%% LOAD DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Load variables
load(data.filenames{1});
for i = data.selection
    load(data.filenames{1});
    data.X{i}                     = eval( data.XDataNames{i} );
    data.Y{i}                     = eval( data.YDataNames{i} );
    
end

%% PLOT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFig                            = figure('MenuBar','none', 'Name', fg.filename, 'NumberTitle', 'off');


for i = 1:length(data.Y)
    line(   data.X{i}, data.Y{i}, ...
        'LineStyle', fg.LineStyle{i}, ...
        'LineWidth', fg.LineWidth{i}, ...
        'Color', fg.Color{i}, ...
        'Marker', fg.Marker{i}, ...
        'MarkerSize', fg.MarkerSize{i}, ...
        'MarkerFaceColor', fg.MarkerFaceColor{i}, ...
        'MarkerEdgeColor', fg.MarkerEdgeColor{i} );
     hold on
end

line([0 fg.axes.xlim(2)], [1 1 ],...
       'LineStyle', ':', ...
       'LineWidth', 2, ...
       'Color', [0.4 0.4 0.4]);
% Int_range=[11.07 2.431];
% for i=1:2
% 
%    line([Int_range(i) Int_range(i)], [0 1],...
%        'LineStyle', ':', ...
%        'LineWidth', 2, ...
%        'Color', fg.Color{4-i}, ...
%        'Marker', fg.Marker{i}, ...
%        'MarkerSize', fg.MarkerSize{i}, ...
%        'MarkerFaceColor', fg.MarkerFaceColor{i}, ...
%        'MarkerEdgeColor', fg.MarkerEdgeColor{i} )
% end
% 
% line([0 fg.axes.xlim(2)], [1 1 ],...
%        'LineStyle', ':', ...
%        'LineWidth', 2, ...
%        'Color', [0.4 0.4 0.4]);



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

%% show max

for i = 1:length(data.Y)
    [m,idx]=(max(data.Y{i}));
    temp=data.X{i};
    temp(idx);
    sprintf('max mu %.3g, range of max mu %.3g\n',m,temp(idx))
end