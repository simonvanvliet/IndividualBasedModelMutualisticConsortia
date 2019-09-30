%% makeFigS8d
clear; close all; clc;


% FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = struct;
fg.filename                     = 'FigS8d';
fg.save                         = 1;

%% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myCOLORS
fg.LineStyle                    = {'none', 'none', '-','-'}; % '-' 'none'
fg.LineWidth                    = {1, 1, 2, 2}; 
fg.Color                        = {yellow*.8, purple,yellow*.8, purple};
fg.Marker                       = { 's', 'o','none','none'}; % 'o' 'none'
fg.MarkerSize                   = {7, 6 ,  6 6}; % 6
fg.MarkerFaceColor              = {'none', 'none','none', 'none'}; % 'none'
fg.MarkerEdgeColor              = {yellow*.8, purple,'none', 'none'}; % 'none'

%% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg.axes.width                   = 1.8; % width of axes in cm
fg.axes.height                  = 3.8; % height of axes in cm
fg.axes.offset                  = [0.9 0.9 0.2 0.]; % offset between axis and figure in cm [bottom left top right]
fg.axes.lineWidth               = 1;

fg.axes.xlabel                  = '';
fg.axes.ylabel                  = 'interaction range [\mum]';
fg.axes.xlabel_offset           = [ 0.0  -0.1];
fg.axes.ylabel_offset           = [ -0.1  0.0];
fg.axes.xtickLabel              = {};
fg.axes.xlim                    = [0 3];
fg.axes.ylim                    = [0 15];
fg.axes.xticks                  = [1,2];
fg.axes.yticks                  = [0:5:15];

%% LOAD DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get data experiment 
load('experimentInteractionRange')
%select consortium 2 (replicate 1-6)
IR_pro_cons2 = radius_of_max_correlation_G(1:6)'*0.041;
IR_trp_cons2 = radius_of_max_correlation_R(1:6)'*0.041;


%get data model, fitted on consortium 1
load('dataFig3c')
IRPMod = correlation.IRPro;
IRTMod = correlation.IRTrp;

data = struct();

barX = [-1 1]*0.3 + 2;
pointX = 0.9 + [0:0.04:0.2]';
data.X = {pointX, pointX , barX, barX};
data.Y = {IR_trp_cons2, IR_pro_cons2, [IRTMod, IRTMod], [ IRPMod, IRPMod]};

%test abs DPro
[h,p]=ttest(IR_pro_cons2-IRPMod);
fprintf('\nIR Pro:\nmean+-std data= %.3g+-%.3g\nmean+-std model= %.3g+-%.3g\np=%.2g\n',...
    mean(IR_pro_cons2),std(IR_pro_cons2),mean(IRPMod),std(IRPMod),p)

%test abs DTrp
[h,p]=ttest(IR_trp_cons2-IRTMod);
fprintf('\nIR Trp:\nmean+-std data= %.3g+-%.3g\nmean+-std model= %.3g+-%.3g\np=%.2g\n',...
    mean(IR_trp_cons2),std(IR_trp_cons2),mean(IRTMod),std(IRTMod),p)




%% PLOT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hFig                            = figure('MenuBar','none', 'Name', fg.filename, 'NumberTitle', 'off');

for i = 1:length(data.X)
    line(   data.X{i}(randperm(length(data.X{i}))), data.Y{i}, ...
            'LineStyle', fg.LineStyle{i}, ...
            'LineWidth', fg.LineWidth{i}, ...
            'Color', fg.Color{i}, ...
            'Marker', fg.Marker{i}, ...
            'MarkerSize', fg.MarkerSize{i}, ...
            'MarkerFaceColor', fg.MarkerFaceColor{i}, ...
            'MarkerEdgeColor', fg.MarkerEdgeColor{i} );
     hold on
     if i<3
        line( [min(data.X{i})-.3 max(data.X{i})+.3], [mean(data.Y{i}) mean(data.Y{i})],'Color',fg.Color{i}, 'LineWidth', 2); 
     end
end


%             'LineStyle', fg.LineStyle{i}, ...
%             'LineWidth', fg.LineWidth{i}, ...
%             'Color', fg.Color{i} ...
%             );

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
hAx.XTickLabel                  = fg.axes.xtickLabel;
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
    %saveas( hFig, [fg.filename '.png'] );
    disp([' * Saved figure in ' fg.filename '.pdf']);
    saveas(hFig, ['/Users/dalcoalm/Dropbox/Alma Figures_shared/figures_all/' fg.filename '.pdf'])
end

%% SHOW MEAN %%%%
%all ten replicates
meanR=mean(data.Y{1});
meanG=mean(data.Y{2});
stdR=std(data.Y{1})
stdG=std(data.Y{2})
sqrtnR=sqrt(length(data.Y{1}));
sqrtnG=sqrt(length(data.Y{2}));
display(['all 10 replicates'])
display(['meanR=',num2str(meanR),'+-',num2str(stdR/sqrtnR),... 
    '  meanG=',num2str(meanG),'+-',num2str(stdG/sqrtnG)]);

%t-test: is R-G coming from a ditribution with mean 0?
[h,p]=ttest(data.Y{1},data.Y{2});
%how far is the estimate of model
modelR=4.5;
modelG=16;
(modelR-meanR)/stdR
(modelG-meanG)/stdG

%get vectors
Y1=data.Y{1};
Y2=data.Y{2};
%label
meanR=mean(Y1(7:10));
meanG=mean(Y2(7:10));
stdR=std(Y1(7:10));
stdG=std(Y2(7:10));
sqrtnR=sqrt(length(Y1(7:10)));
sqrtnG=sqrt(length(Y2(7:10)));
display(['label 4 replicates'])
display(['meanR=',num2str(meanR),'+-',num2str(stdR/sqrtnR),... 
    '  meanG=',num2str(meanG),'+-',num2str(stdG/sqrtnG)]);

%label swap
meanR=mean(Y1(1:6));
meanG=mean(Y2(1:6));
stdR=std(Y1(1:6));
stdG=std(Y2(1:6));
sqrtnR=sqrt(length(Y1(1:6)));
sqrtnG=sqrt(length(Y2(1:6)));
display(['label swap 6 replicates'])
display(['meanR=',num2str(meanR),'+-',num2str(stdR/sqrtnR),... 
    '  meanG=',num2str(meanG),'+-',num2str(stdG/sqrtnG)]);

[h,p]=kstest2(Y1()/Y2(), 4.5/16)
[h,p]=kstest2(Y2(), 16)