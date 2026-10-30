function [ dec] = add2dec(beh,dorun)
%  calculate variables of interest
%
% INPUT:        - dec: "data{is}" field, is data from 1 subject
% PARAMETER:    - dorun: defines what to do
%                   1. Calculate Opponents are Or and Oi for trial types 1-4; define new meta-trialtype (1-2: SvsOr, PvsOr)
%                   2. Correct choice
%                   3.  vdsoc
%                   4. compute S/P/O1/O2-timepos
%%

dec = beh.dec;

%----------------------------------------------------------------------------------------------------------------
%% 1. Calculate Opponents are Or and Oi for trial types 1-4; define new meta-trialtype (1-2: SvsOr, PvsOr)
%----------------------------------------------------------------------------------------------------------------
addmat=[];names={};

if dorun(1)==1
   
   ps  = get_from_mat(dec,{'S','P','O1','O2'});
   tt  = get_from_mat(dec,{'dectype'});
   nt  = numel(tt); % trial nr

   % variables to calculate:
   OrOi   = nan(nt,2);
   ttnew = nan(nt,1);
      
   % 1 vs 3       --> cond1
   % 1 vs 4       --> cond2
   % 2 vs 3       --> cond3
   % 2 vs 4       --> cond4
   % 1&2 vs. 3:4  --> cond5
 
   % self trials recode
   OrOi(tt==1,:) = ps(tt==1,[3 4]);   
   OrOi(tt==2,:) = ps(tt==2,[4 3]);   
   
   % partner trials recode
   OrOi(tt==3,:) = ps(tt==3,[3 4]);   
   OrOi(tt==4,:) = ps(tt==4,[4 3]);     
   
   ttnew(tt==1) = 1;
   ttnew(tt==2) = 1; % 1 is self trials
   ttnew(tt==3) = 2;
   ttnew(tt==4) = 2; % 2 is partner trials
   ttnew(tt==5) = 3; % 3 is group trials
     
   
   % save:
   addmat = [OrOi ttnew]; 
   names  = {'Or','Oi','TT3'};
   
   % put in general matrix, replace if necessary:
   for in=1:numel(names)
      if ismember(names{in},dec.names)
         ind               = find(ismember(dec.names,names{in}));
         dec.mat(:,ind)    = addmat(:,in);
      else
         dec.mat(:,end+1)  = addmat(:,in);
         dec.names{end+1}  = names{in};
      end
   end
end



%----------------------------------------------------------------------------------------------------------------
%% 2. calculate correct choice
%----------------------------------------------------------------------------------------------------------------
addmat=[];names={};  
if dorun(2)==1
   ps          = get_from_mat(dec,{'respDM','OutcomeEng'});
   resp          = ps(:,1);
   outcome       = ps(:,2);
  
   for i=1:size(ps,1)
      if outcome(i)>0 && resp(i)==1 % engage
          addmat(i,1)=1;
      elseif outcome(i)<0 && resp(i)==0  % avoid
          addmat(i,1)=1;
      else
          addmat(i,1)=0;
      end
   end
   names       = {'corchoice'}; 
   
 
   % put in general matrix, replace if necessary:
   for in=1:numel(names)
      if ismember(names{in},dec.names)
         ind               = find(ismember(dec.names,names{in}));
         dec.mat(:,ind)    = addmat(:,in);
      else
         dec.mat(:,end+1)  = addmat(:,in);
         dec.names{end+1}  = names{in};
      end
   end
end

%----------------------------------------------------------------------------------------------------------------
%% 3. VDsoc
%----------------------------------------------------------------------------------------------------------------
addmat=[];names={};  
if dorun(3)==1
   vd  = get_from_mat(dec,{'OutcomeEng'});
   ps  = get_from_mat(dec,{'S','P','Or'});
   oo  = get_from_mat(dec,{'O1','O2'});
   tt  = get_from_mat(dec,{'TT3'});  
   b   = get_from_mat(dec,{'bonus'});  
   
   
   vdsoc        = nan(size(ps,1),1);
   vdsoc(tt==1) = ps(tt==1,1)-ps(tt==1,3);
   vdsoc(tt==2) = ps(tt==2,2)-ps(tt==2,3);
   vdsoc(tt==3) = ps(tt==3,1)+ps(tt==3,2)-oo(tt==3,1)-oo(tt==3,2);
   
   % short errorcheck:
   match = vdsoc+b-vd;
   if sum(abs(match))~=0; disp('error'); keyboard; end

   names  = {'vdsoc'}; 
   addmat =vdsoc;     
 
   % put in general matrix, replace if necessary:
   for in=1:numel(names)
      if ismember(names{in},dec.names)
         ind               = find(ismember(dec.names,names{in}));
         dec.mat(:,ind)    = addmat(:,in);
      else
         dec.mat(:,end+1)  = addmat(:,in);
         dec.names{end+1}  = names{in};
      end
   end
end
%----------------------------------------------------------------------------------------------------------------
%% 4. Timepos
%----------------------------------------------------------------------------------------------------------------
addmat=[];names={};  
if dorun(4)==1
   aoraw  = get_from_mat(dec,{'pos1','pos2','pos3','pos4'});
   ao     = aoraw + 1;
   
   po = aorder2porder(ao);
   
   names  = {'S-TimePos','Pa-TimePos','O1-TimePos','O2-TimePos'}; 
   addmat = po;     
 
   % put in general matrix, replace if necessary:
   for in=1:numel(names)
      if ismember(names{in},dec.names)
         ind               = find(ismember(dec.names,names{in}));
         dec.mat(:,ind)    = addmat(:,in);
      else
         dec.mat(:,end+1)  = addmat(:,in);
         dec.names{end+1}  = names{in};
      end
   end
end

end