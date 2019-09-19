function [yfitted,residuals,varargout]=fitLinRegressionUltraFastV2(x,y)
%this function performs linear regression,
%the core is identical to polyfit with n=1, nyt it is much faster due to
%descreased overhead


%make sure data is column vectors
if isrow(x); x=x'; end
if isrow(y); y=y'; end


%perform fit    
V=[x ones(size(x))];
pfit=V\y; % coefficients of polynomial

yfitted=x*pfit(1)+pfit(2); %fitted value
residuals=y-yfitted; %residual 


varargout{1}=pfit(1);
varargout{2}=pfit(2);

end