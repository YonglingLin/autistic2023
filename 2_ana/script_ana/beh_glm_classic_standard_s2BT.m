function [mat, matnames] = beh_glm_classic_standard_s2BT(dec,doplot)
% Computer decision relevant variables, exports to R
% doexport

% MKW,YL 2022

%%

% fpath = 'figs/';
% opath = 'output_behav/';

%%%%
n = numel(dec);

% for standard glm:

for is = 1:n
    tt   = gfM(dec{is}.dec,{'TT3'});
    X    = gfM(dec{is}.dec,{'S','P','Or','Oi','bonus'});
    Xgroup = gfM(dec{is}.dec,{'S','P','O1','O2','bonus'});
    y    = gfM(dec{is}.dec,'respDM');
      
    mats(is,:) = glmfit(zscore(X(tt==1,:)),y(tt==1),'binomial','link','logit'); 
    matp(is,:) = glmfit(zscore(X(tt==2,:)),y(tt==2),'binomial','link','logit');
    matg(is,:) = glmfit(zscore(Xgroup(tt==3,:)),y(tt==3),'binomial','link','logit'); 
end

% log-transformation:
logmats  = sign(mats).*log(abs(mats)+1); 
logmatp  = sign(matp).*log(abs(matp)+1); 
logmatg  = sign(matg).*log(abs(matg)+1); 

% MAD-outliers label based on S-P-Or-Oi: 
sMADoutliers   = isoutlier(mats(:,[2 3 4 5 6])); 
pMADoutliers   = isoutlier(matp(:,[2 3 4 5 6]));
gMADoutliers   = isoutlier(matg(:,[2 3 4 5 6]));
isMADoutliers  = sum(sMADoutliers,2)>0 | sum(pMADoutliers,2)>0 | sum(gMADoutliers,2)>0; % label 

% all vars
mat      = [isMADoutliers mats matp matg logmats logmatp logmatg];
matnames = {'MADoutliers','Sglm-c','Sglm-S','Sglm-P','Sglm-Or','Sglm-Oi', 'Sglm-bonus',...
               'Pglm-c','Pglm-S','Pglm-P','Pglm-Or','Pglm-Oi','Pglm-bonus', ...
                   'Gglm-c','Gglm-S','Gglm-P','Gglm-O1','Gglm-O2','Gglm-bonus',...
                       'logSglm-c','logSglm-S','logSglm-P','logSglm-Or','logSglm-Oi', 'logSglm-bonus', ...
                          'logPglm-c','logPglm-S','logPglm-P','logPglm-Or','logPglm-Oi', 'logPglm-bonus'...
                             'logGglm-c','logGglm-S','logGglm-P','logGglm-O1','logGglm-O2', 'logGglm-bonus'};


% plot the results                                                        
ids=1:numel(dec);

if doplot
figure;
subplot(2,2,1); visbar_new(mats(:,2:end),{'S','P','Or','Oi','bonus'},'self');
subplot(2,2,2); visbar_new(matp(:,2:end),{'S','P','Or','Oi','bonus'},'partner');
subplot(2,2,3); visbar_new(matg(:,2:end),{'S','P','O1','O2','bonus'},'group');
annotation('textbox', [0.5, 0.98, 0, 0], 'String', 'ClassicGLM', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 14, 'FontWeight', 'bold');

% log transformation
figure;
subplot(2,2,1); visbar_new(logmats(:,2:end),{'S','P','Or','Oi','bonus'},'self');
subplot(2,2,2); visbar_new(logmatp(:,2:end),{'S','P','Or','Oi','bonus'},'partner');
subplot(2,2,3); visbar_new(logmatg(:,2:end),{'S','P','O1','O2','bonus'},'group');
annotation('textbox', [0.5, 0.98, 0, 0], 'String', 'GLM with log', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 14, 'FontWeight', 'bold');

% remove outliers
figure;
subplot(2,2,1); visbar_new(mats(isMADoutliers==0,2:end),{'S','P','Or','Oi','bonus'},'self');
subplot(2,2,2); visbar_new(matp(isMADoutliers==0,2:end),{'S','P','Or','Oi','bonus'},'partner');
subplot(2,2,3); visbar_new(matg(isMADoutliers==0,2:end),{'S','P','O1','O2','bonus'},'group');
annotation('textbox', [0.5, 0.98, 0, 0], 'String', 'GLM (removed outliers)', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 14, 'FontWeight', 'bold');

end


% if doplot
% figure
% subplot(1,2,1)
% visbar(mats,{'Con','S','P','Or','Oi','bonus'},(1:size(mats,1)),'Self Trial',0);
% 
% subplot(1,2,2)
% visbar(matp,{'Con','S','P','Or','Oi','bonus'}, ids, 'Partner Trial',0);
% 
% figure
% subplot(1,2,1)
% visbar(logmats,{'Con','S','P','Or','Oi','bonus'},(1:size(logmats,1)),'Self Trial(log)',0);
% 
% subplot(1,2,2)
% visbar(logmatp,{'Con','S','P','Or','Oi','bonus'}, 1:size(logmats,1), 'Partner Trial(log)',0);
% 
% % Remove outliers
% figure
% subplot(1,2,1)
% visbar(mats(isMADoutliers==0,[2:5]),{'S','P','Or','Oi'}, 1:size(mats(isMADoutliers==0),1),'Self Trial(RemoveOutliers)',0);
% 
% subplot(1,2,2)
% visbar(matp(isMADoutliers==0,[2:5]),{'S','P','Or','Oi'}, 1:size(matp(isMADoutliers==0),1), 'Partner Trial(RemoveOutliers)',0);
% 
% end


end

