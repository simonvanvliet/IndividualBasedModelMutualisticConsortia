%% make FigS3ab
clear; close all;

saveNameVec = {'FigS3a', 'FigS3b'};

for cc = 1:2  %loop DPro and Dtrp (panel a, b)
    %% DATA SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    data = struct;
    data.selection                    = cc; ... %1=pro, 2=try
        data.filenames                    = { ...
        'dataFigS3.mat'; ...
        };
    data.XDataNames                   = {
        'clusterSizeVec' ; ...
        };
    data.YDataNames                   = {
        'RhoSqPro' ; ...
        'RhoSqTrp' ; ...
        'intRangeTrpum' ; ... %is in um
        'intRangeProum' ; ... %is in um
        };
    
    % FIGURE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fg = struct;
    fg.filename                     = saveNameVec{cc};
    fg.save                         = 1;
    
    %% FIGURE LINE SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fg.LineStyle                    = {'-', '-', '-', '-'}; % '-' 'none'
    fg.LineWidth                    = {1.5, 1.5, 1.5, 1.5};
    fg.Color                        = {[0.5 0.0 0.0], [0.0 0.6 0.2], [0.0 0.6 0.2], [0.5 0.0 0.0]};
    fg.Marker                       = {'.', '.', '.', '.'}; % '0' 'none'
    fg.MarkerSize                   = {4, 4, 4, 4}; % 6
    fg.MarkerFaceColor              = {'none', 'none', 'none', 'none', 'none', 'none'}; % 'none'
    fg.MarkerEdgeColor              = {[0.6 0.1 0.1], [0.0 0.5 0.1], [0.0 0.5 0.1], [0.6 0.1 0.1]}; % 'none'
    
    %% FIGURE AXES SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fg.axes.width                   = 3.8; % width of axes in cm
    fg.axes.height                  = 3.8; % height of axes in cm
    fg.axes.offset                  = [1 1 0.2 0.2]; % offset between axis and figure in cm [bottom left top right]
    fg.axes.lineWidth               = 1;
    
    fg.axes.xlabel                  = 'neighbourhood size [\mum]';
    fg.axes.ylabel                  = 'Spearmann \rho';
    fg.axes.xlabel_offset           = [ 0.0  -0.1];
    fg.axes.ylabel_offset           = [ -0.1  0.0];
    
    fg.axes.xlim                    = [0 20];
    fg.axes.ylim                    = [0 1];
    fg.axes.xticks                  = [0:5:25];
    fg.axes.yticks                  = [0:0.2:1];
    
    %% LOAD DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load(data.filenames{1});
    
    %% PLOT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hFig                            = figure('MenuBar','none', 'Name', fg.filename, 'NumberTitle', 'off');
    %plot overlapping camel plots
    cmap=colormap(parula(numClusterSizes));
    
    idx=[2,6,7,8,9,10,11,12,13,14,15];
    for ii= 1:2:length(idx)-1 %loop parameter values
        nn=idx(ii);
        if data.selection==1
            h=plot(radiusVec,sqrt(RhoSqPro{nn}));
            hold on
            set(h,'LineWidth',1.5,'Color',cmap(nn,:))
        end
        if data.selection==2
            h=plot(radiusVec,sqrt(RhoSqTrp{nn}));
            hold on
            set(h,'LineWidth',1.5,'Color',cmap(nn,:))
        end
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
    
end

