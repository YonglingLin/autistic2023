function [S0,S1,S2] = beh_glm_temp_ridge_all_splitRT(S0,S1,S2,doplot)


%YL, 2026

dec_S0 = S0.s.beh;
dec_S1 = S1.s.beh;
dec_S2 = S2.s.beh;

dec_all = {S0.s.beh, S1.s.beh, S2.s.beh};

n1 = numel(dec_S0);
n2 = numel(dec_S1);
n3 = numel(dec_S2);
N = [n1 n2 n3];

lambda  = 0.012; 
% for lassoglm:

for vers = 1:numel(dec_all)
      n = N(vers);
    dec = dec_all{vers};
        for is = 1:n
            tt   = gfM(dec{is}.dec,{'TT3'});
            X    = gfM(dec{is}.dec,{'pcode_xF','scode_xF','bonus'});
            rt   = gfM(dec{is}.dec,'rt');
            if any(strcmp(dec{is}.dec.names, "choice"))  % for S0: lab-based dataset
                 y  = gfM(dec{is}.dec, 'choice');
            else
                 y  = gfM(dec{is}.dec,'respDM'); 
            end
            mat{vers}.mats_fast(is,:) = lassoglm(zscore(X(tt==1&rt<median(rt),:)), y(tt==1&rt<median(rt)), "binomial","Alpha", eps, 'Lambda',lambda);
            mat{vers}.mats_slow(is,:) = lassoglm(zscore(X(tt==1&rt>median(rt),:)), y(tt==1&rt>median(rt)), "binomial","Alpha", eps, 'Lambda',lambda);
            
            mat{vers}.matp_fast(is,:) = lassoglm(zscore(X(tt==2&rt<median(rt),:)), y(tt==2&rt<median(rt)), "binomial","Alpha", eps, 'Lambda',lambda);
            mat{vers}.matp_slow(is,:) = lassoglm(zscore(X(tt==2&rt>median(rt),:)), y(tt==2&rt>median(rt)), "binomial","Alpha", eps, 'Lambda',lambda);
       
        end
      
end 

matnames = {'fast-Sglm-pcodexF','fast-Sglm-scodexF','fast-Sglm-bonus',...
            'slow-Sglm-pcodexF','slow-Sglm-scodexF','slow-Sglm-bonus',...
            'fast-Pglm-pcodexF','fast-Pglm-scodexF','fast-Pglm-bonus',...
            'slow-Pglm-pcodexF','slow-Pglm-scodexF','slow-Pglm-bonus'};

S0.split_temp.mat = [mat{1}.mats_fast, mat{1}.mats_slow, mat{1}.matp_fast, mat{1}.matp_slow];
S0.split_temp.names = matnames;

S1.split_temp.mat = [mat{2}.mats_fast, mat{2}.mats_slow, mat{2}.matp_fast, mat{2}.matp_slow];
S1.split_temp.names = matnames;

S2.split_temp.mat = [mat{3}.mats_fast, mat{3}.mats_slow, mat{3}.matp_fast, mat{3}.matp_slow];
S2.split_temp.names = matnames;



end