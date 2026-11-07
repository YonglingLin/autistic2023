function [DEC,subNos] = loadMainExp(subNos)
% load data
% INPUT:    - Subnos: vector with subject numbers
%
% STEPS:    1. Load data
%           2. Reorganise  data
%%

logpath  = '/Users/marcokwittmann/Documents/PostDoc/projects_lead/social_group/masterlog/groucial_v3_fmri/';
nsub     = length(subNos);
logids   = load([logpath 'logstring_groucialv3_04-Apr-2019.mat']);


%%% Decision making experiment:
%---------------------------------

DEC = {};
for isub = 1:nsub
   % load logfile
   subID = num2str(subNos(isub),'%03d');  
   curfile = [logpath 'S' subID '_DEC_groucialv2'];
   myLog   =  dir([curfile '*.dat']);

   % assign fiels:       
   DEC{isub}.raw.mat       = load([logpath myLog.name]); 
   DEC{isub}.raw.logstring = logids.logstring;
 
   % resort:
   [DEC{isub}.rdmraw,DEC{isub}.dec,DEC{isub}.buffer,DEC{isub}.expdur,DEC{isub}.trigger] = ...
       sortDecData(DEC{isub}.raw.mat,DEC{isub}.raw.logstring) ; 
   
   %  add TimePos in DEC file
   [ok, DEC{isub}] = comptemppos(DEC{isub});
   if  ok == 0; disp('ERROR'); keyboard; end
   
   % rename "handicap" to "bonus"
   hind = find(ismember(DEC{isub}.dec.names,'handicap')); DEC{isub}.dec.names{hind} = 'bonus'; 
   
   % make compressed version of RDMs (1 row per agent per trial instead of 6 rows for 4 agents per trial):
   DEC{isub}.rdm =  compressRDM(DEC{isub}.rdmraw, DEC{isub}.dec); 
   
   % remove some fields to avoid confusion when publishing the data:
   DEC{isub} = rmfield(DEC{isub},'raw');
   DEC{isub} = rmfield(DEC{isub},'rdmraw');
   DEC{isub} = rmfield(DEC{isub},'buffer');
   DEC{isub} = rmfield(DEC{isub},'expdur');
   DEC{isub} = rmfield(DEC{isub},'trigger');
   
end
   



end




