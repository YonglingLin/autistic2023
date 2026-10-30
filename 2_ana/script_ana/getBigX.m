function [T]= getBigX(dec)
% extract the regressors for mix linear model 
% YL 2023
%%

opath = 'Data/';

n= numel(dec);
allVARs = [];

for is= 1:n
    
        y      =    gfM(dec{is}.dec,'respDM');
       tt      =    gfM(dec{is}.dec, 'TT3'); % trial type: 1=self; 2=partner   
      SPOrOi   =    gfM(dec{is}.dec,{'S','P','Or','Oi'});
      SPO1O2   =    gfM(dec{is}.dec,{'S','P','O1','O2'});
      bonus    =    gfM(dec{is}.dec,{'bonus'});

groupd = nan(numel(tt),1);  indiv  = nan(1,numel(tt));
groupmer = nan(numel(tt),1);
% calculate group drive and individual drive:
groupd         =  SPO1O2(:,1)  +  SPO1O2(:,2)  -  SPO1O2(:,3)  -  SPO1O2(:,4);
%groupd        =      SPOrOi(:,1) +  SPOrOi(:,2)    -  SPOrOi(:,3)    -  SPOrOi(:,4);
indiv(tt==1)   =  SPOrOi(tt==1,1) - SPOrOi(tt==1,2) - SPOrOi(tt==1,3) + SPOrOi(tt==1,4);
indiv(tt==2)   = -SPOrOi(tt==2,1) + SPOrOi(tt==2,2) - SPOrOi(tt==2,3) + SPOrOi(tt==2,4);

keyboard % wrong!
%groupmer(tt==1) = SPOrOi(tt==1,2) + SPOrOi(tt==1,4);
%groupmer(tt==2) = SPOrOi(tt==1,1) + SPOrOi(tt==1,4);

Xalt           = [groupd indiv' bonus tt];  %[groupdrive individualdrive bonus]

% adding more Xs: subNo, trialNr, Age, Gender, groupVer, selfSch, SRP, AQ;
tn       = numel(tt); 
trialNo  = [1:tn]';
subNo    = repmat(is,tn,1);
age      = dec{is}.ids.Age;
gender   = dec{is}.ids.Gender;
qnsNames = {'SRP_total', 'AQ_total','AQbinary_total','LA_total','RSS_total', ...
    'SRP_interpersonal','SRP_affective','SRP_liftstyle','SRP_antisocial','SRP_affec_interp','SRP_lifesty_antis',...
    'QCAE_total','QCAE_perspective','QCAE_Simulation','QCAE_Emotional_Contagion','QCAE_Peripheral_Response','QCAE_Proximal_Response',...
    'QCAE_Cog_Empathy','AQ_Social_Skills','AQ_Att_Switch','AQ_Att_Detail','AQ_Communication','AQ_Imagination','AQ_3FM_Social_Skills',...
    'AQ_3FM_Detail','AQ_3FM_Communication','AQ_2FM_Social_Comm','IQ','GAD_total','BDI_total'};
%ver      = dec{is}.vers;

qns      = gfM(dec{is}.qns, qnsNames);
additionalX = repmat([age gender qns],tn,1);
Xs = [subNo trialNo SPOrOi Xalt additionalX y];
allVARs = [allVARs; Xs];

end

names_1 = {'subNo', 'trialNo', 'S','P', 'Or', 'Oi','groupDriv','indivDriv', 'bonus', 'trialtype'...
    'age','gender'};
names = [names_1, qnsNames,'choice'];

T = array2table(allVARs,'VariableNames',names);

writetable([T], [opath 'S2BT_Regressors4LME' '_' date '.csv'])

keyboard