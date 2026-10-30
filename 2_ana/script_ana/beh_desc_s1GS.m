function [mat, matnames] = beh_desc_s1GS(dec,doplot)
% Computer decision relevant variables, exports to R 
% doexport
% MKW,YL 2022

%%

% fpath = 'figs/';
% opath = 'output_behav/';

%%%%
n = numel(dec);

mat = [];
group=[];

for is = 1:n
    tt = gfM(dec{is}.dec,{'TT3'});
    cc = gfM(dec{is}.dec,{'corchoice'});
    rt = gfM(dec{is}.dec,{'rt'});
   
    mat(is,1) = mean(cc(tt==1)); % self trials
    mat(is,2) = median(rt(tt==1));

    mat(is,3) = mean(cc(tt==2)); % partner trials
    mat(is,4) = median(rt(tt==2));
    
    mat(is,5) = dec{is}.ver.group;
    mat(is,6) = dec{is}.ver.self;
 
end

matnames = {'corS','rtS','corP','rtP','groupver','selfsch'};


if doplot

corr=mat(:,[1 3]);
Corrnames={'Self','Partner'}; figure;
subplot(1,2,1)
visbar(corr,Corrnames,1:size(corr,1),'%Correct',0);

rt = mat(:,[2 4]); 
subplot(1,2,2)
visbar(rt,Corrnames,1:size(rt,1),'Median Reaction times',0);
%saveas(gcf,[fpath 'Desc_DyadicMatched_' date]);
end

end

