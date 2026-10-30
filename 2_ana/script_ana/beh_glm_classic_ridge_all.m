function [S0, S1, S2] = beh_glm_classic_ridge_all(S0, S1, S2 ,doplot)
% Computer decision relevant variables, exports to R
% doexport

% MKW,YL 2022

%    S0: lab-setting dataset
%    S1: S1GS online dataset
%    S2: S2BT online dataset
%----------------------------------

dec_S0 = S0.s.beh;
dec_S1 = S1.s.beh;
dec_S2 = S2.s.beh;
dec_all = {S0.s.beh, S1.s.beh, S2.s.beh};

n1 = numel(dec_S0);
n2 = numel(dec_S1);
n3 = numel(dec_S2);
N = [n1 n2 n3];

%%

% for lassoglm:
for vers = 1:numel(dec_all)
      n = N(vers);
    dec = dec_all{vers};
        for is = 1:n
            tt   = gfM(dec{is}.dec,{'TT3'});
            X    = gfM(dec{is}.dec,{'S','P','Or','Oi','bonus'});
            Xgroup = gfM(dec{is}.dec,{'S','P','O1','O2','bonus'});
           
            if any(strcmp(dec{is}.dec.names, "choice"))  % for S0: lab-based dataset
                 y  = gfM(dec{is}.dec, 'choice');
            else
                 y  = gfM(dec{is}.dec,'respDM'); 
            end

            s.X{is} = X(tt==1,:);
            s.y{is} = y(tt==1);
            p.X{is} = X(tt==2,:);
            p.y{is} = y(tt==2);
            g.X{is} = Xgroup(tt==3,:);
            g.y{is} = y(tt==3);     
        end

        sXverName = sprintf('s%d.X', vers); %Generate the variable name dynamically
        sYverName = sprintf('s%d.y', vers);
        pXverName = sprintf('p%d.X', vers); 
        pYverName = sprintf('p%d.y', vers);

        eval([sXverName ' = s.X']);
        eval([sYverName ' = s.y']);
        eval([pXverName ' = p.X']);
        eval([pYverName ' = p.y']);
end 


% do ridge regressions on all dataset and both Self and Partner trials.
b123_sp = ridgeAll({s1.X{:} s2.X{:} s3.X{:} p1.X{:} p2.X{:} p3.X{:}}, {s1.y{:} s2.y{:} s3.y{:} p1.y{:} p2.y{:} p3.y{:}},'classic'); disp('ridge classic')


bs1 = b123_sp(1:n1,:);
bs2 = b123_sp(n1+1:(n1+n2),:);
bs3 = b123_sp(n1+n2+1:(n1+n2+n3),:);

bp1 = b123_sp([n1+n2+n3+1]:[n1+n2+n3+n1],:);
bp2 = b123_sp([n1+n2+n3+n1+1]:[n1+n2+n3+n1+n2],:);
bp3 = b123_sp([n1+n2+n3+n1+n2+1]:2*[n1+n2+n3],:);

matnames = {'Sglm-c','Sglm-S','Sglm-P','Sglm-Or','Sglm-Oi', 'Sglm-bonus',...
               'Pglm-c','Pglm-S','Pglm-P','Pglm-Or','Pglm-Oi', 'Pglm-bonus'};

% all vars
S0.cglm.mat = [bs1 bp1];
S0.cglm.names = matnames;

S1.cglm.mat = [bs2 bp2];
S1.cglm.names = matnames;

S2.cglm.mat = [bs3 bp3];
S2.cglm.names = matnames;


if doplot
    figure;
    subplot(3,2,1); visbar_new(bs1(:,2:end),{'S','P','Or','Oi','bonus'},'self (S0)');
    subplot(3,2,2); visbar_new(bp1(:,2:end),{'S','P','Or','Oi','bonus'},'partner (S0)');

    subplot(3,2,3); visbar_new(bs2(:,2:end),{'S','P','Or','Oi','bonus'},'self (S1)');
    subplot(3,2,4); visbar_new(bp2(:,2:end),{'S','P','Or','Oi','bonus'},'partner (S1)');

    subplot(3,2,5); visbar_new(bs3(:,2:end),{'S','P','Or','Oi','bonus'},'self (S1)');
    subplot(3,2,6); visbar_new(bp3(:,2:end),{'S','P','Or','Oi','bonus'},'partner (S1)');
   
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

