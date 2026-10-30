function [mat,matnames] = beh_rdm(rdm,doplot)
% descriptive function for plotting behaviour
% YL & MKW 2022
%%

n = numel(rdm);

resp = [];
corr = [];
rt   = [];
coh  = [];

for is = 1:n
       rdm1 = table2array(rdm{is}.tbl_rdm);                             
       coh  = rdm{is}.tbl_rdm.coh; 
       rt   = rdm{is}.tbl_rdm.rt;
       resp = rdm{is}.tbl_rdm.resp;
       corr = rdm{is}.tbl_rdm.corr;                    % correct information: corr:1; incorr:-1; miss: NaN;
      
       mat(is,1)  = sum(~isnan(corr))/size(rdm1,1);    % response rate: the percentage of response;
       mat(is,2)  = sum(corr==1)/size(rdm1,1);         % corr trials: including missing trials;
       mat(is,3)  = mean(rdm1(~isnan(corr),4));        % the mean of rt: excluding missing trials; 
   
       mat(is,4)  = sum(resp(coh==-0.5120)==1)/numel(resp(coh==-0.5120)); % the percentage of choosing right when the coherence is -0.5120 (negative)
       mat(is,5)  = sum(resp(coh==0.5120)==1)/numel(resp(coh==0.5120));   % the percentage of choosing right when the coherence is 0.5120 (positive)

       mat(is,6)  = sum(resp(coh==-0.0320)==1)/numel(resp(coh==-0.0320)); % the percentage of choosing right when the coherence is -0.0320
       mat(is,7)  = sum(resp(coh==0.0320)==1)/numel(resp(coh==0.0320));   % the percentage of choosing right when the coherence is 0.0320

       mat(is,8)  = sum(corr(coh==-0.5120)==1)/numel(corr(coh==-0.5120)); % the percentage of corr when the coherence is -0.5120 (negative)
       mat(is,9)  = sum(corr(coh==0.5120)==1)/numel(corr(coh==0.5120));   % the percentage of corr when the coherence is 0.5120 (positive)

       mat(is,10)  = sum(corr(coh==-0.0320)==1)/numel(corr(coh==-0.0320)); % the percentage of corr when the coherence is -0.0320
       mat(is,11)  = sum(corr(coh==0.0320)==1)/numel(corr(coh==0.0320));   % the percentage of corr when the coherence is 0.0320



end


matnames = {'rdm_resp','rdm_corr','rdm_rt', 'rdm_resp_n0.512','rdm_resp_p0.512', 'rdm_resp_n0.0320','rdm_resp_p0.0320','rdm_corr_n0.512','rdm_corr_p0.512', 'rdm_corr_n0.0320','rdm_corr_p0.0320'};

%exportCsv([outfolder 'beh_rdm_' date], mat, {'resp','corr','rt'})  

%plot the result                                                     
ids=1:numel(rdm);

if doplot

%resp
resp=mat(:,1);
Corrnames={'resp'}; figure;
subplot(1,3,1)
visbar(resp,Corrnames,ids,'%resp',0);

%corr

corr=mat(:,2);
Corrnames={'corr'};
subplot(1,3,2)
visbar(corr,Corrnames, ids, '%corr',0);

%reaction time
rt=mat(:,3);
Corrnames={'rt'};
subplot(1,3,3)
visbar(rt,Corrnames, ids, 'Reaction time',0);

end

end