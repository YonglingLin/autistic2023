function beh_desc_tc(dec,doexport)
% Computer decision relevant variables, exports to R
% MKW,YL 2022


%%
% important timing variables:
%binsize     = [32 16 8 4 2 1];                                              % all possible bin sizes that respect training/test boundary
binsize     = [32 16 8 4]
%%%%%%%%

fpath = 'figs/';
opath = 'output_behav/';


%%%%
n    = numel(dec);
VV   = {'w5w7','w5w8','w6w7','w6w8'}; 
for is = 1:n
    tt = gfM(dec{is}.dec,{'TT3'});
    cc = gfM(dec{is}.dec,{'corchoice'});
    rt = gfM(dec{is}.dec,{'rt'});
   
    cci(is,:) = cc(tt<3); % indiv trials
    rti(is,:) = rt(tt<3);
    
    vers(is) = find(ismember(VV,dec{is}.vers)); 
end


%%%%%%%%%%%%%%% 1. Plot % correct
figure;
for ibin = 1:numel(binsize)
    [ccicur,lab] = bintc(cci,binsize(ibin));
    subplot(2,3,ibin)
    for iv = 1:4
        ep{iv} = errorbar((1:numel(lab))+iv*0.05, mean(ccicur(vers==iv,:)), getSE(ccicur(vers==iv,:)),'Color',sC(VV{iv}),'Linewidth',2); hold all;
        plot((1:numel(lab))+iv*0.05, mean(ccicur(vers==iv,:)), 'o', 'MarkerSize', 11,  'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', sC(VV{iv}));
        set(gca,'xtick',1:numel(lab),'xticklabels',lab)
        xlim([.5, numel(lab)+.5]);
        ylim([.3 1])
    end
    title(['%correct - binsize= ' num2str(binsize(ibin))])
    legend([ep{:}],VV)
    setfp(gcf)
end
saveas(gcf,[fpath 'behtc_corr_' date]);

%%%%%%%%%%%%%%% 1. Plot RT (copy from above)
figure;
for ibin = 1:numel(binsize)
    [ccicur,lab] = bintc(rti,binsize(ibin));
    ccicur = log(ccicur);
    subplot(2,3,ibin)
    for iv = 1:4
        ep{iv} = errorbar((1:numel(lab))+iv*0.05, mean(ccicur(vers==iv,:)), getSE(ccicur(vers==iv,:)),'Color',sC(VV{iv}),'Linewidth',2); hold all;
        plot((1:numel(lab))+iv*0.05, mean(ccicur(vers==iv,:)), 'o', 'MarkerSize', 11,  'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', sC(VV{iv}));
        set(gca,'xtick',1:numel(lab),'xticklabels',lab)
        xlim([.5, numel(lab)+.5]);
     %    ylim([.3 1])
    end
    title(['logRT - binsize= ' num2str(binsize(ibin))])
    legend([ep{:}],VV)
    setfp(gcf)
end
saveas(gcf,[fpath 'behtc_logRT_' date]);



end

