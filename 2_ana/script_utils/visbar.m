function visbar(B,Bnames,ids,tit,legendOn)
% small script to visualise GLM
%
% MKW, Nov 2020
%% 

ncol = size(B,2);
subCol=cbrewer('qual','Set2',numel(ids));
bpl = bar(1:ncol, mean(B ,1)); hold on
set(bpl,'Facecolor','w');
errorbar(1:ncol, mean(B,1),getSE(B),'k.'); hold all;
%for is=1:numel(ids)
%   hsub{is} = plot((1:ncol)+.2,B(is,:),'o--','Linewidth',2,'Color',subCol(is,:)); hold all;
%end

for is=1:numel(ids)
   hsub{is} = plot((1:ncol)+.2,B(is,:),'o-','Linewidth',2,'Color',subCol(is,:)); hold all;
end


xlim([.5 size(B ,2)+.5]);
plot(xlim,[0 0],'k');
set(gca, 'xtick',1:numel(Bnames),'xticklabel',Bnames);
title(tit);
if legendOn == 1 

   leg = legend([hsub{:}],num2str(ids(1:numel(ids))'),'autoupdate','off'); 
   %label={'YL','LJ','CQ','H1','H2','JZ','YL','LJ','CQ','SL','CH','JZ'}'
   %leg = legend([hsub{:}],label,'autoupdate','off');
   
end
setfp(gcf)



end

