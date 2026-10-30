function [D,B,lspace,kfold,ncv] = ridgeSub(y,X,lam)
% runs ridge glm for a specific session/subject 
%
% Input:    - y
%           - X: Design matrix
%           - lam: if a lambda is specified, then deviance (D)  and beta (B) output will be specified for this lambda, otherwise output is over all lambdas
%           
% OUTPUT:   - D: deviance matrix as 1 x nLambda, unless lam-input is specified, then output is single deviance value for this lambda
%           - B: nB x nLambda matrix, unless lam-input is specified, then output is nB x 1 for this lambda  
%           - lspace: lambda space (set to lam if lam is defined)
%           - kfold: how many folds were used for crossvalidation (output this only for information)
%           - ncv: number of crossvalidation runs
%
%%


% ridge settings:
alpha    = eps;                                                               % makes the elastic net (i.e. lassoglm) practically a ridge regression
lspace   = [0 logspace(-3,-1,12)];                                            % logspace(a,b,n)  generates n points between decades 10^a and 10^b.
ncv      = 2;                                                                 % how often the crossvalidation is repeated - was 10
kfold    = 3;                                                                 % do k-fold crossvalidation, i.e. lassoglm partitions data in 5 folds, trains on 4, tests on 1, does this 5 times, once per partition

%lspace was 100, kfold was 5

% do this to get output only for a single lambda
if nargin == 3
   lspace = lam;
end

% Get betas for all lambdas

for icv = 1:ncv
   [bs,Fitinfo]   = lassoglm(zscore(X),y,'binomial','Alpha',alpha,'Lambda',lspace,'CV',kfold);
   D(icv,:)       = Fitinfo.Deviance;
end 
B = [Fitinfo.Intercept;bs];                                                   % nB x nLambda output;  note that the B is the same for each CV iteration, bc betas are only determined by the lambda and apply to all the data; durinc crossvalidation, only deviance changes based on partitining; nB x nLambda output
D = mean(D);                                                                  % average deviance; 1 x nlambda output













end

