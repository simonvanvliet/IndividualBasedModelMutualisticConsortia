%% makeFig S8a
clear; close all;



%% DATA SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inputData = struct;
dataFileName  = 'experimentInteractionRange.mat';
modelFileName = 'dataFigS8.mat';

data = processData(modelFileName, dataFileName);

XDataNames                   = {'logRl','logRl'};
YDataNames                   = {'IR_trp','trpMeanVec'};
CIYDataNames                 = {'trpCIVec'};
CIXDataNames                 = {'xCIVec'};

% FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = struct;
fg.filename                     = 'FigS8b';
fg.save                         = 1;

%% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myCOLORS;
dTcol                           = yellow*.8;
dPcol                           = purple;
ratioCol                        = [0.15 0.15 0.15];

fg.CIAlpha                      = {0.3};
fg.CIColor                      = {dTcol};
fg.CIEdgeColor                  = {'none', 'none'};

fg.LineStyle                    = {'-', '-.'};
fg.LineWidth                    = {2, 1};
fg.Color                        = {dTcol, [dTcol .6]};
fg.Marker                       = {'none', 'none'};
fg.MarkerSize                   = {4, 4}; % 6
fg.MarkerFaceColor              = {'none', 'none'};
fg.MarkerEdgeColor              = {'none','none'};

fg.LineStyleRl                  = {':'};
fg.LineWidthRl                  = {2};
fg.ColorRl                      = {'k'};

%% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.axes.width                   = 3.8; % width of axes in cm
fg.axes.height                  = 3.8; % height of axes in cm
fg.axes.offset                  = [1 0.9 0.2 0.2]; % offset between axis and figure in cm [bottom left top right]
fg.axes.lineWidth               = 1;

fg.axes.xlabel                  = 'leakage rate log_{10}(r^l) 1/s';
fg.axes.ylabel                  = 'interaction range \mum';
fg.axes.xlabel_offset           = [ 0.0  0.0];
fg.axes.ylabel_offset           = [ -0.1  0.0];

fg.axes.xlim                    = [-8 -3];
fg.axes.ylim                    = [0 20];
fg.axes.xticks                  = -8:1:-2;
fg.axes.yticks                  = 0:5:20;


%% PLOT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFig                            = figure('MenuBar','none', 'Name', fg.filename, 'NumberTitle', 'off');

for i = 1:length(XDataNames)
    
    line(   data.(XDataNames{i}), data.(YDataNames{i}), ...
        'LineStyle', fg.LineStyle{i}, ...
        'LineWidth', fg.LineWidth{i}, ...
        'Color', fg.Color{i}, ...
        'Marker', fg.Marker{i}, ...
        'MarkerSize', fg.MarkerSize{i}, ...
        'MarkerFaceColor', fg.MarkerFaceColor{i}, ...
        'MarkerEdgeColor', fg.MarkerEdgeColor{i} );
    hold on
    
end

for i = 1:length(CIXDataNames)
    
    fill(   data.(CIXDataNames{i}), data.(CIYDataNames{i}), ...
        fg.CIColor{i},...
        'FaceAlpha', fg.CIAlpha{i},...
        'EdgeColor', fg.CIEdgeColor{i});
    hold on
    
end

%get predicted IR for default rl

%get real leakage rates
settings    = SteadyState_2D_SettingsRevision;
rlTrp       = settings.rl * sqrt(settings.delta_l) / settings.tD_s;
logrl       = log10(rlTrp);

[~, idx] = min(abs(data.(XDataNames{i}) - logrl));
IRpredicted = data.(YDataNames{i})(idx);

line([logrl logrl], [0 IRpredicted],....
    'LineStyle', fg.LineStyleRl{1}, ...
    'LineWidth', fg.LineWidthRl{1}, ...
    'Color', fg.ColorRl{1})

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



function data = processData(modelDataFile, dataDataFile)

%load model
load(modelDataFile)
inputData = struct;
%load data
%% STATISTICAL TEST PREDICTED VALUE VS REPLICATES
%files with replicated mesurements of interaction range
inputData.filenames2                    = { ...
    dataDataFile ; ...
    dataDataFile ; ...
    };
inputData.YDataNames2                   = { ...
    'radius_of_max_correlation_R' ; ...
    'radius_of_max_correlation_G' ; ...
    };

%store correctly the label swap
for i = 1:2
    load(inputData.filenames2{i});
    inputData.Y2{i}                     = eval( inputData.YDataNames2{i} )*0.041; %0.041 = micrometer per pixel
end

for nReplicate=7:10
    % correct for fluor swap
    temp = inputData.Y2{1}(nReplicate); inputData.Y2{1}(nReplicate) = inputData.Y2{2}(nReplicate); inputData.Y2{2}(nReplicate) = temp;
end

%create output structure
data = struct;

%Process Data
IR_pro_data = inputData.Y2{2};
IR_trp_data = inputData.Y2{1};
ratio_data = IR_pro_data./IR_trp_data;

%get CI
[meanPro,ciUpPro,ciDownPro,ciDevPro]=createConfInterval(IR_pro_data');
[meanTrp,ciUpTrp,ciDownTrp,ciDevTrp]=createConfInterval(IR_trp_data');
[meanRatio,ciUpRatio,ciDownRatio,ciDevRatio]=createConfInterval(ratio_data');

%store data
data.IR_pro_data = IR_pro_data;
data.IR_trp_data = IR_trp_data;


%setup vectors for plotting
oneVec= ones(size(modelOutput.rl_abs));
data.xCIVec = log10([modelOutput.rl_abs fliplr(modelOutput.rl_abs)]);
data.proCIVec = [oneVec*ciUpPro oneVec*ciDownPro];
data.trpCIVec = [oneVec*ciUpTrp oneVec*ciDownTrp];
data.ratioCIVec = [oneVec*ciUpRatio oneVec*ciDownRatio];

data.proMeanVec = oneVec*meanPro;
data.trpMeanVec = oneVec*meanTrp;
data.ratioMeanVec = oneVec*meanRatio;

%process model
data.logRl = log10(modelOutput.rl_abs);
data.ratioModel = modelOutput.IR_pro./modelOutput.IR_trp;
data.IR_pro = modelOutput.IR_pro(1,:);
data.IR_trp = modelOutput.IR_trp(1,:);

data.delta = modelOutput.delta;

end

