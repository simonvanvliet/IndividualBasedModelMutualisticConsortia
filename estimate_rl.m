%FINAL VERSION 18-Nov-2018
%Updated to include measured mu_wt

%fit max mu of data (estimated by extrapolating lin regression)
%to analytical limit of predicted mu_max
%note we actually fit IC*rl as only the product matters we can fix IC to default value of 20

%SET estimated mu max from data (slope+offset)
estimatedMuMaxPro=0.7552; % in h-1; UPDATE NOV 14;
estimatedMuMaxTrp=0.2153; % in h-1; UPDATE NOV 14; 


%SET fixed IC (default=20)
fixedIC=20;
muMax = 3600/2790; % in h-1; UPDATED NOV 18 from data
tds = 3600/muMax;
tdh = 1/muMax;
%run script to estimate rl and delta
rlRangeExt = logspace(log10(1E-5),log10(1E5),1E7);


%% estimate rl from theory
%theoretical prediction for I_Lim and mu_max
f_ILim = @(IC,rl) ( (IC-1)*rl + sqrt( ((IC+1)*rl).^2 + 4*(muMax).*(rl*IC)) ) ./ ( 2*(muMax+rl));  
predictedILim = f_ILim(fixedIC, rlRangeExt);
predictedMu = muMax*predictedILim./(1+predictedILim);

%find rl that most closely matches observed mu_max
devDPro = abs(predictedMu-estimatedMuMaxPro);
devDTrp = abs(predictedMu-estimatedMuMaxTrp);

[~,rlProInd] = min(devDPro);
[~,rlTrpInd] = min(devDTrp);

rlProMod = rlRangeExt(rlProInd);
rlTrpMod = rlRangeExt(rlTrpInd);
deltaMod = rlTrpMod/rlProMod;
rlMod = sqrt(rlProMod*rlTrpMod);

fprintf('\nfit to theory\nrl pro=%.3e s-1, rl trp=%.3e s-1\nrl=%.3e s-1delta=%.3g, 1/delta=%.3g\n',...
    rlProMod/3600,rlTrpMod/3600,rlMod/3600,deltaMod,1/deltaMod)


%% estimate rl from theory, using assumption IC>>1
%theoretical prediction for muMax (assuming IC>>1)
muMax_simple = @(IC,rl) (IC.*rl/2).*(sqrt(1 + 4*muMax./(rl.*IC)) - 1);
predictedMuSimple = muMax_simple(fixedIC, rlRangeExt);

%find rl that most closely matches observed mu_max
devDPro = abs(predictedMuSimple-estimatedMuMaxPro);
devDTrp = abs(predictedMuSimple-estimatedMuMaxTrp);

[~,rlProInd] = min(devDPro);
[~,rlTrpInd] = min(devDTrp);

rlProModSim = rlRangeExt(rlProInd);
rlTrpModSim = rlRangeExt(rlTrpInd);
deltaModSim = rlTrpMod/rlProMod;
rlModSim = sqrt(rlProMod*rlTrpMod);


fprintf('\nfit to theory, assuming IC>>1\nrl pro=%.3e s-1, rl trp=%.3e s-1\nrl=%.3e s-1, delta=%.3g, 1/delta=%.3g\n',...
    rlProModSim/3600,rlTrpModSim/3600,rlModSim/3600,deltaModSim,1/deltaMod)



%% plot things
greenC=[0,136,55]/256;
redC=[202,0,32]/256;

figure(101)
hold off
h=semilogx(rlRangeExt,predictedMu);
hold on
l1=line(([rlRangeExt(1) rlRangeExt(end)]),[estimatedMuMaxPro estimatedMuMaxPro]);
l2=line(([rlRangeExt(1) rlRangeExt(end)]),[estimatedMuMaxTrp estimatedMuMaxTrp]);

l3=line([rlProMod rlProMod],[0 1.5]);
l4=line([rlTrpMod rlTrpMod],[0 1.5]);

axis([rlRangeExt(1) rlRangeExt(end) 0 1.5])

set(h(1),'Color','k','LineWidth',2);
%set(h(2),'Color',redC,'LineWidth',2);

set(l1,'Color',greenC,'LineWidth',1,'LineStyle',':');
set(l2,'Color',redC,'LineWidth',1,'LineStyle',':');
set(l3,'Color',greenC,'LineWidth',1,'LineStyle',':');
set(l4,'Color',redC,'LineWidth',1,'LineStyle',':');
ylabel('predicted mu_max')
title(sprintf('fit to theory rl=%.3g 1/delta=%.3g',rlMod,1/deltaMod))

