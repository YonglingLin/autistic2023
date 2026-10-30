function [mat, matnames] = beh_glm_temp_s2BT(dec,doplot)
% descriptive function for calculating GLM
% MKW 2022
%%

% 
% fpath = 'figs/';
% opath = 'output_behav/';

n = numel(dec);
for is = 1:n
    y      =    gfM(dec{is}.dec,'respDM');
    tt     =    gfM(dec{is}.dec,'TT3');                              % trial type; 1 = self, 2= partner
  SPOrOi   =    gfM(dec{is}.dec,{'S','P','Or','Oi','bonus'});
  bonus    =    gfM(dec{is}.dec,{'bonus'});
    rt     =    gfM(dec{is}.dec,{'rt'});

    groupd = nan(numel(tt),1);  indiv  = nan(1,numel(tt));
    
    % calculate group drive and individual drive:
      groupd       =   SPOrOi(:,1) +  SPOrOi(:,2)   -  SPOrOi(:,3)   -  SPOrOi(:,4);
    indiv(tt==1)   =  SPOrOi(tt==1,1) - SPOrOi(tt==1,2) - SPOrOi(tt==1,3) + SPOrOi(tt==1,4);
    indiv(tt==2)   = -SPOrOi(tt==2,1) + SPOrOi(tt==2,2) - SPOrOi(tt==2,3) + SPOrOi(tt==2,4);
       Xalt        = [groupd indiv' bonus];  

 % standard glm:      
    mats(is,:) = glmfit(zscore(Xalt(tt==1,:)),y(tt==1),'binomial','link','logit');
    matp(is,:) = glmfit(zscore(Xalt(tt==2,:)),y(tt==2),'binomial','link','logit');

 % look at the modulation by reaction time
   mats_fast(is,:) = glmfit(zscore(Xalt(tt==1&rt<median(rt),:)),y(tt==1&rt<median(rt)),'binomial','link','logit'); % self trial;
   mats_slow(is,:) = glmfit(zscore(Xalt(tt==1&rt>=median(rt),:)),y(tt==1&rt>=median(rt)),'binomial','link','logit'); %self trial;
   
   matp_fast(is,:) = glmfit(zscore(Xalt(tt==2&rt<median(rt),:)),y(tt==2&rt<median(rt)),'binomial','link','logit'); % partner trial;
   matp_slow(is,:) = glmfit(zscore(Xalt(tt==2&rt>=median(rt),:)),y(tt==2&rt>=median(rt)),'binomial','link','logit'); % partner trial;

clear indiv group

end

% log-transformation:
logmats  = sign(mats).*log(abs(mats)+1); 
logmatp  = sign(matp).*log(abs(matp)+1); 

logmats_fast = sign(mats_fast).*log(abs(mats_fast)+1);
logmats_slow = sign(mats_slow).*log(abs(mats_slow)+1);

logmatp_fast = sign(matp_fast).*log(abs(matp_fast)+1);
logmatp_slow = sign(matp_slow).*log(abs(matp_slow)+1);


% MAD-outliers label based on group/indiv: 
sMADoutliers   = isoutlier(mats(:,[2 3])); 
pMADoutliers   = isoutlier(matp(:,[2 3]));
isMADoutliers = sum(sMADoutliers,2)>0 | sum(pMADoutliers,2)>0; % label 


% all vars
mat      = [isMADoutliers mats matp logmats_fast logmats_slow logmatp_fast logmatp_slow]; %logmats
matnames = {'tempMADoutliers','Stemp-c','Stemp-groupdri','Stemp-individri','Stemp-bonus',...
                   'Ptemp-c','Ptemp-groupdri', 'Ptemp-individri', 'Ptemp-bonus', ...  
                      'Sfast-c', 'Sfast-groupdri', 'Sfast-individri', 'Sfast-bonus','Sslow-c', 'Sslow-groupdri', 'Sslow-individri', 'Sslow-bonus',...
                          'Pfast-c', 'Pfast-groupdri', 'Pfast-individri', 'Pfast-bonus','Pslow-c', 'Pslow-groupdri', 'Pslow-individri','Pslow-bonus'};


ids=1:numel(dec);
% export
if doplot
    figure
    visbar(mats,{'Con','GroupDrive','IndividualDrive','bonus'},ids,'Self Trial',0);
    figure;
    visbar(matp,{'Con','GroupDrive','IndividualDrive','bonus'}, ids, 'Partner Trial',0);
end


end

