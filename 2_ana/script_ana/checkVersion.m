function  checkVersion(data,schedule)
% cross checks if logfile data is consistent with expected input schedule
% MKW 2023
%
%
%
%% 

% get the current schedule, and rearrange in format of logfile: 1st dec, 2nd dec, etc
curs = schedule.(data.vers);

mat1 = [];
for it = 1:size(curs.dec,1)
   curline1 =  [curs.X.m(it,:) curs.ao(it,:) curs.dec(it,1) curs.hcap(it,1)]; % dec1
   curline2 =  [curs.X.m(it,:) curs.ao(it,:) curs.dec(it,2) curs.hcap(it,2)]; % dec2
   mat1     =  [mat1; curline1; curline2];
end

% get data in the same format
mat2 = gfM(data.dec, {'S','P','O1','O2','pos1','pos2','pos3','pos4','dectype','bonus'});
mat2(:,5:8) = mat2(:,5:8) + 1;                                                         % remember that pos is coded 0-3, not 1-4

% compare data and schedule and give error message if mismatch:
if ~isequal(mat1,mat2), disp('ERROR'); keyboard; end
  





end

