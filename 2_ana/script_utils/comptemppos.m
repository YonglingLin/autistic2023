function [ok,DECOUT] = comptemppos(DEC)
% compute which temporal position agents have during RDM presentation
% MKW, Jan 2019
%%

ok = 1;



% now check agentorder:
nt          = get_from_mat(DEC.rdmraw,'trialNo');
nrdm        = get_from_mat(DEC.rdmraw,'rdmNo');
aid         = get_from_mat(DEC.rdmraw,'agentID');
aloc        = get_from_mat(DEC.rdmraw,'agentLoc'); 
aidRecode   = [];
if unique(aloc-aid)>4, ok= 0; disp('Error'); keyboard; end                 % if this is above 4, then the same agent has been given two different spatial position which cannot be
for it=1:max(nt)
   ind = find(nt==it&nrdm==1);
   curseqag    = aid(ind);                   

   % recode aid to use it as a regressor:
   aidRecode =  [aidRecode; find(curseqag==1) find(curseqag==2) find(curseqag==3) find(curseqag==4)]; % now coded as S-Pa-O1-O2 and numbers in matrix mean which position they have (first, second...)
   aidRecode(end+1,:) = aidRecode(end,:); % repeat this to put this into the decision matrix next
end

addmat   = aidRecode;
names    = {'S-TimePos','Pa-TimePos','O1-TimePos','O2-TimePos'}; % "Agent-Positions 1-4:  players referred to as 1 (=S), 2 (=partner), 3 and 4 (the two opponents)
% put in general matrix, replace if necessary:
for in=1:numel(names)
   if ismember(names{in},DEC.dec.names)
      ind                   = find(ismember(DEC.dec.names,names{in}));
      DEC.dec.mat(:,ind)    = addmat(:,in);
   else
      DEC.dec.mat(:,end+1)  = addmat(:,in);
      DEC.dec.names{end+1}  = names{in};
   end
end

   
%
DECOUT = DEC;





end

