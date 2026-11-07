function [betas] = beh_simsub_temp(regs,ws,trialtype,subdata)
% simulates self-choices based on regressors to be used (regs) and weighted in a certain way (Ws)
% ws: beta;
% tt: trialtype

% simulate
tt      = gfM(subdata,'TT2');
X       = gfM(subdata,regs);
X       = X(tt==trialtype,:);   
% without DV

cprobS  = glmval([0 ws]',zscore(X),'logit');
choice  = rand(numel(cprobS),1) <(cprobS);      

% fit:
rnames = {'S','P','Or','Oi','bonus'};
Xnew   = gfM(subdata,rnames);
Xnew   = Xnew(tt==trialtype,:);
betas  = glmfit(zscore(Xnew),choice,'binomial','link','logit'); 



