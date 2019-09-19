function [muTryHM, muProHM, varargout]=SteadyState_2D_Calc_GrowthRangeSplitWorld(muX)
%calc growth range for splitWorld grid

%SET DEBUG
DEBUG=0;

%SET sample interval
dxSample=0.1;

%mid point, everyting to the right of this point is DPro
midPoint=floor(length(muX)/2);

%extract growth DPro and DTrp
muTry=muX(1:midPoint);
muPro=muX(midPoint+1:end);

%store interface growth
varargout{1}=muTry(end);
varargout{2}=muPro(1);

%set x grid
xDTry=1:midPoint;
xDPro=1:(length(muX)-midPoint);
xDTryFine=1:dxSample:midPoint;
xDProFine=1:dxSample:(length(muX)-midPoint);

%interpolate growth rates to allow for non integere range
try
    muTryInterp=interp1(xDTry,muTry,xDTryFine,'pchip');
    muTryHM=sum(muTryInterp>(0.5*muTry(end)))/length(xDTryFine)*midPoint;
catch
    muTryHM=nan;
end
    
try
    muProInterp=interp1(xDPro,muPro,xDProFine,'pchip');
    muProHM=sum(muProInterp>(0.5*muPro(1)))/length(xDProFine)*(length(muX)-midPoint);
catch
    muProHM=nan;
end

%plot growth curves for debugging
if DEBUG
    figure(3033)
    plotGrowthCurveSplitWorld(muX,[],'growth profile')
    k1=line(midPoint-[muTryHM muTryHM],[0 1]);
    k2=line(midPoint+1+[muProHM muProHM],[0 1]);
    
    k11=line([1 midPoint],0.5*[muTry(end) muTry(end)]);
    k21=line([midPoint+1 length(muX)],0.5*[muPro(1) muPro(1)]);
    
    set(k1,'Color',[202,0,32]/256,'LineWidth',2)
    set(k2,'Color',[0,136,55]/256,'LineWidth',2)
    
    set(k11,'Color',[202,0,32]/256,'LineWidth',1,'LineStyle','--')
    set(k21,'Color',[0,136,55]/256,'LineWidth',1,'LineStyle','--')
    hold off
end
    