function [SignificanceGroupsCellArray,significanceGroupsString]=findSignificanceGroupsMultiComp(stats,multiCompareTable,alpha)
%use to find significance groups.
%run after a mulitple comparison test to find groups that have no significant 
% difference between them
%
%input: 
%stat: output structure of anova/kruskal-wallis, etc
%multiCompareTable: output of multcompare function
%alpha: (optional, default 0.05), significance level below which groups are
%considered to be different
%
%output:
%SignificanceGroupsCellArray: cell array, each entry is vector of groups
%that are not significantly different
%significanceGroupsString: string, each line list groups that are not
%significnatly different 
%
% %to plot significance groups the following code can be used:
% numSigLetLoc=zeros(1,numGroups); %this vector keeps track of vertical displacement
% sigLetters={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p'};
% startY=1; %adjust to set height of first nr (in axis units)
% deltaY=0.5; %adjust to set offset between letters (in axis units)
% for sigG=1:length(SignificanceGroupsCellArray)
%     groupsToPlot=SignificanceGroupsCellArray{sigG};
%     
%     %y-loc
%     minY=max(numSigLetLoc(groupsToPlot));
%     ytext=ones(size(xtext))*startY+deltaY*minY;
% 
%     %x-loc
%     xtext=xVec(groupsToPlot);
%     text(xtext,ytext,sigLetters{sigG},'FontName','Arial','FontSize',5,'HorizontalAlignment','center')
% 
%     numSigLetLoc(groupsToPlot)=numSigLetLoc(groupsToPlot)+1;
% end

if nargin<3
    alpha=0.05;
end

if isfield(stats,'meanranks')
numGroups=length(stats.meanranks);
elseif isfield(stats,'means')
numGroups=length(stats.means);
else
    error('I don''t know what the group size is')
end

significantPairwiseDifference=multiCompareTable(multiCompareTable(:,end)<alpha,[1 2 6]);

Groups={1:numGroups};

for cc=1:size(significantPairwiseDifference,1) %loop all significantly different pairs
    %check for each current significance whether both members of significnatly
    %different pair are part of current group, if yes split this group into
    %two
    for gg=1:length(Groups) 
        t1=significantPairwiseDifference(cc,1);
        t2=significantPairwiseDifference(cc,2);
        currGroup=Groups{gg};
        if sum(t1==currGroup)>0 && sum(t2==currGroup)>0 %significant difference in current group
            %create two new group, each having different member of the
            %significant pair
            newGroup1=currGroup;
            newGroup2=currGroup;
            newGroup1(newGroup1==t1)=[]; 
            newGroup2(newGroup2==t2)=[];
            
           %check if new group is subset of existing significance group.
           %only add the new groups if this is not the case
            group1IsNew=1;
            group2IsNew=1;
            
            for ggint=1:length(Groups) %loop all groups
                if ggint~=gg
                    if isempty(setdiff(newGroup1,Groups{ggint})) %check if new group 1 is subset of existing group
                        group1IsNew=0;
                    end
                     if isempty(setdiff(newGroup2,Groups{ggint})) %check if new group 2 is subset of existing group
                        group2IsNew=0;
                     end  
                end
            end
            
            Groups{gg}=[]; %remove old group
            
            %store new groups
            if group1IsNew==1
                Groups{end+1}=newGroup1;
            end
            if group2IsNew==1
                Groups{end+1}=newGroup2;
            end
        end
    end
end


%%
%clean up empty groups
SignificanceGroupsCellArray={};
significanceGroupsString='';
for gg1=1:length(Groups)
    if ~isempty(Groups{gg1})
        if length(Groups{gg1})>1
            SignificanceGroupsCellArray{1,end+1}=Groups{gg1};
            currGroup=sprintf('%.2i ',Groups{gg1});
            significanceGroupsString=sprintf('%s\n%s',significanceGroupsString,currGroup);
        end
    end
end



            