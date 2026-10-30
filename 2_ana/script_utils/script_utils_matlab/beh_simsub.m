function [betas,percCor] = beh_simsub(regs,ws,trialtype,subdata)
% simulates self-choices based on regressors to be used (regs) and weighted in a certain way (Ws)
% ws: beta;
% tt: trialtype

% simulate
tt      = gfM(subdata,'TT2');
X       = gfM(subdata,regs);
X       = X(tt==trialtype,:);                                                       % select trial types.
DV      = X(:,trialtype)-X(:,3);

ws = 0.8;
cprobS  = glmval([0 ws]',zscore(DV),'logit');
choice  = rand(numel(cprobS),1) <(cprobS);      

% fit:
rnames = {'S','P','Or','Oi'};
Xnew   = gfM(subdata,rnames);
Xnew   = Xnew(tt==trialtype,:);
betas  = glmfit(zscore(Xnew),choice,'binomial','link','logit'); 

% get percentage correct
corc   = gfM(subdata,'OutcomeEng'); 
percCor = mean((corc(tt==trialtype)>0)==choice);


