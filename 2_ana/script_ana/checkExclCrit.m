function [crit,critnames] = checkExclCrit(subdata)
% checks exclusion criterion for a single subject, set to 1 if excluded
% MKW 2023


critnames = {'TimeCrit','scrCrit','rtCrit','corrCrit','respCrit','catchCrit'};
crit = zeros(numel(critnames),1);

% 1. Time Crit:
totaltime     =(subdata.ids.DMend-subdata.ids.RDMstart);
totaltime_qns = subdata.qns.mat(end) - subdata.ids.DMend;
crit(1)       = totaltime>120 | totaltime_qns > 120;

% 2. scrCrit:
crit(2) = subdata.ids.browserinteract_test==0; % DISABLED
crit(2) = 0;

% 3. rtCrit:
above30 = gfM(subdata.dec,'rt_30');
crit(3) = mean(above30)>.1;

% 4. corrCrit: 
cc         =  gfM(subdata.dec,'corchoice');
crit(4)    = mean(cc) < .55;
% crit(4)    = 0;

% 5. respCrit:
c         =  gfM(subdata.dec,'respDM');
rdm       =  subdata.tbl_rdm.resp;
cfail     = .15 < mean(c) < .85;                    % 1 if failed
rdmfail   = .15 < mean(sign(rdm==1)) < .85;         % 1 if failed
crit(5)   = max([cfail, rdmfail]);

%6. catchCrit
catchC    = gfM(subdata.qns,'catch_accuracy');
crit(6)   = catchC < 1;                         % 1 if failed
% crit(6)   = 0;

end

