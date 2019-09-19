%% makeFig S10a
%plot dependance of Deff and Deff/alpha to density
clear; close all; 


% FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = struct;
fg.filename                     = 'FigS10a';
fg.save                         = 1;

%% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myCOLORS;
DeffCol                         = [0 0 0];
DeffAlphaCol                    = [0.5 0.5 0.5];
fg.LineStyle                    = {'-', '-.', ':'}; % '-' 'none'
fg.LineWidth                    = {2, 2, 1};
fg.Color                        = {DeffCol,DeffAlphaCol, [0 0 0]};
fg.Marker                       = {'none', 'none', 'none'}; % '0' 'none'
fg.MarkerSize                   = {4, 4, 4}; % 6
fg.MarkerFaceColor              = {'none', 'none', 'none'}; % 'none'
fg.MarkerEdgeColor              = {'none', 'none', 'none'}; % 'none'


%% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.axes.width                   = 5; % width of axes in cm
fg.axes.height                  = 3.8; % height of axes in cm
fg.axes.offset                  = [0.9 0.9 0.2 0.2]; % offset between axis and figure in cm [bottom left top right]
fg.axes.lineWidth               = 1;

fg.axes.xlabel                  = 'cell density';
fg.axes.ylabel                  = 'log_{10} relative diffusion';
fg.axes.xlabel_offset           = [ 0.0  0.0];
fg.axes.ylabel_offset           = [ 0.0  0.0];

fg.axes.xlim                    = [0 1];
fg.axes.ylim                    = [-4 2];
fg.axes.xticks                  = [0:0.25:1];
fg.axes.yticks                  = [-4:2:2];

fg.legendText                   = {'D^{eff}/D','D^{eff}/\alphaD'};

%% Calculate DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get settings
settings=SteadyState_2D_SettingsRevision;

%select range of density to scan
rhoMin=0;
rhoMax=1;
rho=linspace(rhoMin,rhoMax,1000);

%get parameters
DeffFac = (1-rho)./(1+rho/2);
DeffAlpha = (1-rho)./(1+rho/2) .* (1-rho)./rho;

%setup data to plot
data = struct;
data.X = {rho, rho, rho};
yVec = ones(size(rho));
data.Y = {log10(DeffFac), log10(DeffAlpha), log10(yVec)};


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


%Add legend
legend(fg.legendText,...
    'Location','SouthWest',...
    'FontName', 'Arial',...
    'FontWeight', 'normal',...
    'FontSize', 9)
legend('boxoff')

%% SAVE FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if fg.save
    saveas( hFig, [fg.filename '.pdf']);
    disp([' * Saved figure in ' fg.filename '.pdf']);
end





