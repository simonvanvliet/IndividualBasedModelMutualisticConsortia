%% makeFig4b
%plot correlation analysis of model and data
clear; close all; 

%% DATA SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = struct;
data.selection                    = [1 2 3 4]; ... 
data.filenames                    = { ...
    'dataFig3c';...
    'dataFig3c';...
    'experimentalCorrelationAnalysis.mat';
    'experimentalCorrelationAnalysis.mat';
    };
data.XDataNames                   = { 
    'correlation.range' ; ...
    'correlation.range' ; ...
    'correlation.range' ; ...
    'correlation.range' ; ...
    };
data.YDataNames                   = { 
    'correlation.roTrp' ; ...
    'correlation.roPro' ; ...
    'correlation.roGreen' ; ...
    'correlation.roRed' ; ...
    };
data.show                         = {1:100 1:100 2:100 2:100};


% FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = struct;
fg.filename                     = 'Fig3c';
fg.save                         = 1;

%% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
greenC                          = [0.0 0.6 0.2 ];
redC                            = [0.5 0.0 0.0 ];
myCOLORS;
dTcol                           = yellow*.8;
dPcol                           = purple;
fg.LineStyle                    = {'-', '--', '-', '--'}; % '-' 'none'
fg.LineWidth                    = {1.5, 1.5, 1.5, 1.5};
fg.Color                        = {dTcol,dPcol, [dTcol .6], [dPcol .6]};
fg.Marker                       = {'.', '.', '.', '.'}; % '0' 'none'
fg.MarkerSize                   = {4, 4, 4, 4}; % 6
fg.MarkerFaceColor              = {'none', 'none', 'none', 'none', 'none', 'none'}; % 'none'
fg.MarkerEdgeColor              = {dTcol*.5,dPcol*.5, 'none', 'none'}; % 'none'


%% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.axes.width                   = 3.8; % width of axes in cm
fg.axes.height                  = 3.8; % height of axes in cm
fg.axes.offset                  = [0.9 0.9 0.2 0.2]; % offset between axis and figure in cm [bottom left top right]
fg.axes.lineWidth               = 1;

fg.axes.xlabel                  = 'neighbourhood size [\mum]';
fg.axes.ylabel                  = 'Spearmann \rho';
fg.axes.xlabel_offset           = [ 0.0  0.0];
fg.axes.ylabel_offset           = [ 0.0  0.0];

fg.axes.xlim                    = [0 25];
fg.axes.ylim                    = [0 1];
fg.axes.xticks                  = [0:5:25];
fg.axes.yticks                  = [0:0.2:1];

%% LOAD DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = data.selection 
    load(data.filenames{i});
    data.X{i}                     = eval( data.XDataNames{i} );
    data.Y{i}                     = eval( data.YDataNames{i} );
    
    if i<=2
        data.X{i}                     = (data.X{i}-1)*1.5; %still needed 
    end
    
    if i>2
        data.X{i}                     = data.X{i}*0.041;
    end  

end

for i = data.selection
    data.idx                      = data.show{i};
    data.idx( data.idx > numel(data.X{i}) ) = [];
    data.X{i}                     = data.X{i}(data.idx);
    data.Y{i}                     = data.Y{i}(data.idx);
    
   
end

%% PLOT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFig                            = figure('MenuBar','none', 'Name', fg.filename, 'NumberTitle', 'off');

for i = 1:length(data.X)
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


%% SHOW WHERE MAX IS %%%%%%%%%%%
for jj=1:length(data.selection)
    [m(jj),idx(jj)]= max(data.Y{data.selection(jj)});
    display(data.filenames{data.selection(jj)})
    data.X{data.selection(jj)}(idx(jj))
end

%% STATISTICAL TEST PREDICTED VALUE VS REPLICATES
%load file with replicated mesurements of interaction range
expData = load('experimentInteractionRange.mat');

%convert to um
IRGreen = expData.radius_of_max_correlation_G*0.041; %0.041 = micrometer per pixel;
IRRed = expData.radius_of_max_correlation_R*0.041; %0.041 = micrometer per pixel;

%assign color to strain
%replicate 1-6 DPro=Green, replicate 7-10 DPro=Red
IRPdata = [IRGreen(1:6) IRRed(7:10)];
IRTdata = [IRRed(1:6) IRGreen(7:10)];

%ratio pro/try in data
ratioData=IRPdata./IRTdata;

%get data model
load('dataFig3c')
IRPMod = correlation.IRPro;
IRTMod = correlation.IRTrp;

%ratio pro/try in model
ratioModel = IRPMod / IRTMod;

%test ratio
[h,p]=ttest(ratioModel-ratioData);
fprintf('\nRatio IRPro/IRTrp:\nmean+-std data= %.2g+-%.2g\nmean+-std model= %.2g+-%.2g\np=%.2g\n',...
    mean(ratioData),std(ratioData),mean(ratioModel),std(ratioModel),p)

%test abs DPro
[h,p]=ttest(IRPdata-IRPMod);
fprintf('\nIR Pro:\nmean+-std data= %.3g+-%.3g\nmean+-std model= %.3g+-%.3g\np=%.2g\n',...
    mean(IRPdata),std(IRPdata),mean(IRPMod),std(IRPMod),p)

%test abs DTrp
[h,p]=ttest(IRTdata-IRTMod);
fprintf('\nIR Trp:\nmean+-std data= %.3g+-%.3g\nmean+-std model= %.3g+-%.3g\np=%.2g\n',...
    mean(IRTdata),std(IRTdata),mean(IRTMod),std(IRTMod),p)


