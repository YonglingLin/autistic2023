function [RDM] = compressRDM(rdmraw,dec)
% checks if logfile is internally consistent
% MKW, Jan 2019
%%



%%% collect sequential information
datmat = get_from_mat(rdmraw,{ 'trialNo', 'agentID','response_correct','fb_onset'});
tn = datmat(:,1); aid = datmat(:,2); rc = datmat(:,3); ron = datmat(:,4);
rdmperf  = nan(max(tn),6,4);
rdmon    = nan(max(tn),6,4); % onsets of indivisual RDMs
counter = 1;
for it=1:max(tn)
   for ia = 1:4
      rdmperf(it,:,ia) = rc(tn==it&aid==ia)';
      rdmon(it,:,ia)   = ron(tn==it&aid==ia)';
   end
end

% reformat RDMs:
matout = []; 
oldvn  = {'subNo','sesNo','trialNo','agentID','agentLoc','dotstart_time','dotend_time','agentCol','dot_direction'}; % old variable names to carry over
input  = gfM(rdmraw,oldvn);
tn     = gfM(rdmraw,'trialNo');
irdm   = gfM(rdmraw,'rdmNo');
aid    = gfM(rdmraw,'agentID');
% collect also order information from decision matrix:
timepos= gfM(dec,{'S-TimePos','Pa-TimePos','O1-TimePos','O2-TimePos'});
dectnr = gfM(dec,{'decNo'});
timepos = timepos(dectnr==1,:);                                               % because matrix same for dec1 and dec2
% assemble:
for it=1:max(tn)
   for ia = 1:4
      newrow = [];
      newrow = input(tn==it&aid==ia&irdm==1,:);                                % use first rdm row only because information is identical for the 6 RDMs
      % add sequential performance information
      matout(end+1,:) =  [newrow sum(rdmperf(it,:,ia)) rdmperf(it,:,ia) rdmon(it,:,ia) timepos(it,ia)]; 
   end
end
newvarn =  {'perf','rdm1cor','rdm2cor','rdm3cor','rdm4cor','rdm5cor','rdm6cor','rdm1on','rdm2on','rdm3on','rdm4on','rdm5on','rdm6on','timepos'};
% dotstart_time,       interval per agent (~2sec), ~0.3 sec before rdm1on
% dotend_time,         end of that interval,       ~0.2 sec after rmd6on
% perf                 cumulative performance, 0-6
% rdm1-6               1/0 depending on correctness
% rdm1-6on             onset times of those rdms
% timepos              1-4, depending on when that agent was shown
allvarn = {oldvn{:} newvarn{:}}; 

% define output: 
%RDM.mat     = matout;   % non-table version
%RDM.names   = allvarn'; % non-table version
RDM = array2table(matout,'variablenames',allvarn); % make this a table



%% do some error checks to make sure it works

% check order, checked
%mat = gfM(RDM,{'dotstart_time', 'rdm1on','rdm2on','rdm3on','rdm4on','rdm5on','rdm6on','dotend_time'});
%keyboard
% timepos, checked
%start = gfM(RDM,{'dotstart_time',})
%pos   = gfM(RDM,{'timepos'})
%posorder=[start(pos==1),start(pos==2),start(pos==3),start(pos==4)]; % looks right
%plot(posorder(1:26,:))


% perf = dec perf, checked, gives zero
%decpo  = gfM(dec,{'S','P','O1','O2'});
%dectnr = gfM(dec,{'decNo'}); decpo = decpo(dectnr==1,:);
%mat    = gfM(RDM,{'agentID','perf'});
%for i =1:4
%   diffmat = [mat(mat(:,1)==i,2) decpo(:,i)];
%   diffmat(:,2)-diffmat(:,1)
%end


end

