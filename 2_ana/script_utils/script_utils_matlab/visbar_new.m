function visbar_new(B,Bnames,tit)
% small script to visualise GLM
%
% MKW, Nov 2020
%% 

ncol = size(B,2);
bpl = bar(1:ncol, mean(B ,1));  hold on
set(bpl,'Facecolor','r');
errorbar(1:ncol, mean(B,1),getSE(B),'k.'); hold all;

for is=1:size(B,1)
   hsub{is} = plot((1:ncol)+.2,B(is,:),'o','Linewidth',.1,'Color','k'); hold all;
end


xlim([.5 size(B ,2)+.5]);
plot(xlim,[0 0],'k');
set(gca, 'xtick',1:numel(Bnames),'xticklabel',Bnames);
title(tit);
setfp(gcf)



end

