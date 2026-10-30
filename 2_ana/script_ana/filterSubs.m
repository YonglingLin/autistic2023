function sclean = filterSubs(s, doprint)
% Filters out subjects, applies exclusion criteria; also builds stable
% MKW, 2023


figpath = 'figs';


out = [];
%%%---------------------------------------------------------------------------------------------------------------------------------
% 1. check exclusion crits

for is = 1:numel(s.beh)    
    [out(is,:),n] = checkExclCrit(s.beh{is});
end
% calculate who to exclude:
kick = sum(out,2)>0;
keep = 1 - kick;



%%% plot exclusion criterions
if doprint
    figure;
    bar(sum(out));
    set(gca,'xtick',1:numel(n),'xticklabels',n)
    ylabel(['Exclusion criteria fullfilled'])
    title(['Sample size n = ' num2str(sum(keep)) ' (' num2str(sum(kick)) ' persons excluded)']); 
    saveas(gcf,[figpath '/exclusions_' date])
end


%%%---------------------------------------------------------------------------------------------------------------------------------
% 2. Now filter

cc = 1;
sclean = {};
for is = 1:numel(s.beh)
    if keep(is) == 1
        sclean.beh{cc} = s.beh{is};
        cc = cc + 1;
    end
end



