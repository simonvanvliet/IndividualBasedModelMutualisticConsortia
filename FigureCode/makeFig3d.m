%% makeFig3d
%plot binned growth of model vs data
%% SET BIN SIZE AND REBIN DATA
close all;

%% DATA SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = struct;
data.setSelection                 = {1,2};
data.filenames                    = { ...
                                    'experimentalBinnedGrowthRate';...
                                     'dataFig3d';...
                                    };
                              
data.varName                      = { ...
                                    'Exp';...
                                    'Mod';...
                                  };
                              
data.XDataNames                   = { ...
                                    'x_binned' ; ...
                                  };
data.YDataNames                   = { ...
                                    'y_binned' ; ...
                                  };
% dt.show                         = [2:100];
                              
% FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = struct;
fg.filename                     = ['Fig3d'];
fg.save                         = 1;
fg.adjust                       = 1;

%% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% greenC                          = [141,211,199]/255;
% redC                            = [251,128,114]/255;
greenC                          = [0.0 0.6 0.2];
redC                            = [0.5 0.0 0.0];
myCOLORS;
dTcol                           = yellow*.8;
dPcol                           = purple;

fg.LineStyle                    = {'-', '--'}; % '-' 'none'
fg.LineWidth                    = {1}; 
fg.Color                        = {[0.0 0.0 0.0 0.5], [0.0 0.0 0.0 0.5]};...{[0.5 0.0 0.0],[0.0 0.6 0.2]}; % 4th number is transparency
fg.Marker                       = {'o','s'}; % 'o' 'none'
fg.MarkerSize                   = {6, 7}; % 6
fg.MarkerEdgeColor              = {dPcol,dTcol}; % 'none'
fg.MarkerFaceAlpha              = {0};
fg.MarkerFaceColor              = {'none','none'}; ...[0.5 0.0 0.0 ],[0.0 0.6 0.2 ]}; % 'none'
fg.LabelFontSize                = 9;
fg.TickFontSize                 = 7;
fg.textX                        = {0.05, 0.05};
fg.textY                        = {0.95, 0.88};
fg.textColor                    = {dPcol,dTcol};
fg.textSize                     = 9;


%% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.axes.width                   = 3.8; % width of axes in cm
fg.axes.height                  = 3.8; % height of axes in cm
fg.axes.offset                  = [1. 1.2 0.3 0.3]; % offset between axis and figure in cm [bottom left top right]
fg.axes.lineWidth               = 1;

fg.axes.xlabel                  = 'growth rate data  [1/h]';
fg.axes.ylabel                  = 'growth rate model [1/h]';
fg.axes.xlabel_offset           = [ 0.0  -0.1];
fg.axes.ylabel_offset           = [ -0.1  0.0];

fg.axes.xlim                    = [0 .75];
fg.axes.ylim                    = [0 .75];
fg.axes.xticks                  = [0:0.25:.75];
fg.axes.yticks                  = [0:0.25:.75];

%% LOAD DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ss=1:length(data.setSelection) %load all types
    for ii=1:length(data.filenames) %load multiple data sets
        input=load([data.filenames{ii}]);
        for jj=1:length(data.XDataNames) %load multiple variables
            tempY                           = input.(data.YDataNames{jj});
            tempX                           = input.(data.XDataNames{jj});
            xName                           = [data.XDataNames{jj},data.varName{ii}];
            yName                           = [data.YDataNames{jj},data.varName{ii}];
            data.(yName){ss}                = tempY{data.setSelection{ss}}(:);
            data.(xName){ss}                = tempX{data.setSelection{ss}}(:);
        end
    end
end


%% PLOT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFig                            = figure('MenuBar','none', 'Name', fg.filename, 'NumberTitle', 'off');

xName = 'y_binnedExp'; 
yName = 'y_binnedMod';
    
    
for i = 1:length(data.(xName))
    
     xData=data.(xName){i};
     yData=data.(yName){i};
          
     notNan=~isnan(xData+yData);
     xData=xData(notNan);
     yData=yData(notNan);
     
     
%     line(  xData, yData, ...
%             'Marker', fg.Marker{i}, ...
%            % 'SizeData', fg.MarkerSize{1}, 
%             'MarkerFaceColor', fg.MarkerFaceColor{i}, ...
%             'MarkerFaceAlpha', fg.MarkerFaceAlpha{1}, ...
%             'MarkerEdgeColor', fg.MarkerEdgeColor{i} );
%      hold on;
%      
     
     line(   xData, yData, ...
        'LineStyle', 'none', ...
        'Marker', fg.Marker{i}, ...
        'MarkerSize', fg.MarkerSize{i}, ...
        'MarkerFaceColor', fg.MarkerFaceColor{i}, ...
        'MarkerEdgeColor', fg.MarkerEdgeColor{i});
    hold on;
    
     %perform regression
     r2=corr(xData,yData)^2;
     fit=polyfit(xData,yData,1);
     
     xPred=fg.axes.xlim;
     yPred=xPred*fit(1)+fit(2);
     
     fprintf('r2 = %.2g, slope=%.2g, offset=%.2g\n',r2,fit)
     
     %add regression info
%      fitDescrip=sprintf('y=%#.2gx+%#.2g, R^2=%#.2g',fit(1),fit(2),r2);
%      t=text(fg.textX{i},fg.textY{i},fitDescrip,'Units','normalized');
%      t.FontSize=fg.textSize;
%      t.Color=fg.textColor{i};
     
     line(   xPred, yPred, ...
            'LineStyle', fg.LineStyle{1}, ...
            'LineWidth', fg.LineWidth{1}, ...
            'Color', fg.Color{data.setSelection{i}}, ...
            'Marker', 'none' );
end


%% ADJUST FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if fg.adjust
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
hAx.FontSize                    = fg.TickFontSize;

hAx.XLabel.String               = fg.axes.xlabel;
hAx.XLabel.Units                = 'centimeter';
hAx.XLabel.FontName             = 'Arial';
hAx.XLabel.FontWeight           = 'normal';
hAx.XLabel.FontSize             = fg.LabelFontSize;
hAx.XLabel.Position             = [fg.axes.xlabel_offset 0] + hAx.XLabel.Position;
hAx.YLabel.String               = fg.axes.ylabel;
hAx.YLabel.Units                = 'centimeter';
hAx.YLabel.FontName             = 'Arial';
hAx.YLabel.FontWeight           = 'normal';
hAx.YLabel.FontSize             = fg.LabelFontSize;
hAx.YLabel.Position             = [fg.axes.ylabel_offset 0] + hAx.YLabel.Position;
end

%% SAVE FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if fg.save
    saveas( hFig, [fg.filename '.pdf']);
    disp([' * Saved figure in ' fg.filename '.pdf']);
end

