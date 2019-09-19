function [meanDat,ciUp,ciDown,ciDev,varargout]=createConfInterval(data,varargin)
%expexts replicates in columns
meanDat=nan(1,size(data,2));

ciUp=nan(1,size(data,2));
ciDown=nan(1,size(data,2));
ciDev=nan(1,size(data,2));
summaryStat=nan(6,size(data,2));

for i=1:size(data,2)
    currData=data(:,i);

    meanData=nanmean(currData);
    stdData=nanstd(currData);
    nData=sum(~isnan(currData));
    tDist = tinv(0.975,nData-1);
    sem=stdData./sqrt(nData);
    ciDeviation=tDist.*sem;
    ciUp(i)=meanData+ciDeviation;
    ciDown(i)=meanData-ciDeviation;
    ciDev(i)=ciDeviation;
    meanDat(i)=meanData;
    
    if ~isempty(varargin)
        expectedValue=varargin{1};
        if ~isnan(expectedValue(i));
            [~,p]=ttest(removeNanVector(currData-expectedValue(i)));
        else
            p=nan;
        end
        summaryStat(:,i)=[meanData;stdData;ciUp(i);ciDown(i);nData;p];
   end
    
    
end

if ~isempty(varargin)
    varargout{1}=summaryStat;
end