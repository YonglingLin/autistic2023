function [mat, matnames] = beh_glm_classic_ridge_s2BT(dec,doplot)
% Computer decision relevant variables, exports to R
% doexport

% MKW,YL 2022

%%

n = numel(dec);

% for lassoglm:

for is = 1:n
    tt   = gfM(dec{is}.dec,{'TT3'});  %'ttsame'
    X    = gfM(dec{is}.dec,{'S','P','Or','Oi','bonus'});
    Xgroup = gfM(dec{is}.dec,{'S','P','O1','O2','bonus'});
    y    = gfM(dec{is}.dec,'respDM'); 

    s.X{is} = X(tt==1,:);
    s.y{is} = y(tt==1);
    p.X{is} = X(tt==2,:);
    p.y{is} = y(tt==2);
    g.X{is} = Xgroup(tt==3,:);
    g.y{is} = y(tt==3);    

end

bs = ridgeAll(s.X,s.y,'selfclassic');    disp('ridge self')
bp = ridgeAll(p.X,p.y,'partneclassic');  disp('ridge partner')
bg = ridgeAll(g.X,g.y,'groupclassic');   disp('ridge group')


% all vars
mat = [bs bp bg];
matnames = {'Sglm-c','Sglm-S','Sglm-P','Sglm-Or','Sglm-Oi', 'Sglm-bonus',...
               'Pglm-c','Pglm-S','Pglm-P','Pglm-Or','Pglm-Oi', 'Pglm-bonus', ...
                  'Gglm-c','Gglm-S','Gglm-P','Gglm-O1','Gglm-O2', 'Gglm-bonus'};

if doplot
    figure;
    subplot(2,2,1); visbar_new(bs(:,2:end),{'S','P','Or','Oi','bonus'},'self (ridge)');
    subplot(2,2,2); visbar_new(bp(:,2:end),{'S','P','Or','Oi','bonus'},'partner (ridge)');
    subplot(2,2,3); visbar_new(bg(:,2:end),{'S','P','O1','O2','bonus'},'group (ridge)');
 end

% % % plot the results
%  if doplot
%  figure
%  subplot(1,2,1)
%  visbar(bs, {'Con','S','P','Or','Oi','bonus'}, 1:size(bs,1), 'Self Trial(lasso)',0);
%  
%  subplot(1,2,2)
%  visbar(bp, {'Con','S','P','Or','Oi','bonus'}, 1:size(bp,1), 'Partner Trial(lasso)',0);
%  end



end

