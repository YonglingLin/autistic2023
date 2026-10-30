function [beh] = addTempFun(beh)
% adds variables that have to do with the temporal basis vectors
% INPUT:        - beh: is behaviour from 1 participant


% weights for temporal functions
tc = [  -1 1 -1 1; ... % 1
        1 1 -1 -1; ... % 2
        1 -1 -1 1];    % 3

% code performances as sequence 1,2,3,4
pos   = gfM(beh.dec,{'S-TimePos','Pa-TimePos','O1-TimePos','O2-TimePos'});
perf  = gfM(beh.dec,{'S','P','O1','O2'});
psequ = [];
for it = 1:size(beh.dec.mat,1)
    curpos          = pos(it,:);
    curperf         = perf(it,:);
    [~,sortcode]    = sort(curpos);
    psequ(it,:)     = curperf(sortcode);
end

% the three temporal basis vectors
bfun = psequ*tc';

% primary code and whether it is flipped
for it = 1:size(beh.dec.mat,1)
    curseq          = psequ(it,:);
     % this is the current primary group configuration in temporal space, e.g. [1 -1 1 -1] for S,O1,P,O2
    curp(it,:)          = [1 1 1 1];
    curp(it, pos(it,3)) = -1;
    curp(it, pos(it,4)) = -1;                                                   
    pcode(it,:)         = bfun(it,(curp(it,:)*tc'~=0));                                 % product is unequal zero for correct temporal function
    pflip(it,:)         = sign(mean(curp(it,:)*tc'))<0;                                 % sign of product tells you if flip was necessary  
end
pcode_xF           = pcode;
pcode_xF(pflip==1) = -pcode(pflip==1);


% secondary code and whether it is flipped
tt      = gfM(beh.dec,{'dectype'}); % get trial type
scode   = NaN(size(tt));
sflip   = NaN(size(tt));
scode_xF= NaN(size(tt)); 
for it = 1:size(beh.dec.mat,1)
    decTemp(it,:) = [0 0 0 0];
    if      tt(it) == 1, decTemp(it,pos(it,1)) = 1; decTemp(it,pos(it,3)) = -1; 
    elseif  tt(it) == 2, decTemp(it,pos(it,1)) = 1; decTemp(it,pos(it,4)) = -1; 
    elseif  tt(it) == 3, decTemp(it,pos(it,2)) = 1; decTemp(it,pos(it,3)) = -1; 
    elseif  tt(it) == 4, decTemp(it,pos(it,2)) = 1; decTemp(it,pos(it,4)) = -1; 
    elseif  tt(it) == 5, continue;
    end
    
   match  = (curp(it,:)+tc)./2 == decTemp(it,:);                                        % find correct other basis function to get decision, either positive or negative
   codenr = find(sum(abs(match),2)==4);
   sflip(it) = 0;
   if numel(codenr)<1
       match  = (curp(it,:)-tc)./2 == decTemp(it,:);
       codenr = find(sum(abs(match),2)==4);
       sflip(it) = 1;
   end
   scode(it) = bfun(it,codenr);
end
scode_xF           = scode;
scode_xF(sflip==1) = -scode(sflip==1);


% number of non-zero dimensions:
bfundims = sum(bfun~=0,2); 


%% now save:
addmat = [psequ, bfun, pcode, scode, pcode_xF,pflip, scode_xF,sflip, bfundims];
names = { ...
    'p1','p2','p3','p4',...                                                             % code performances as sequence 1,2,3,4
    'tc1','tc2','tc3', ...                                                              % the three temporal basis vectors
    'pcode','scode', ...                                                                % primary and secondary code
    'pcode_xF','p_flip', ...                                                            % flipped primary vector and information if it was flipped or not
    'scode_xF','s_flip',...                                                             % flipped secondary vector and information if it was flipped or not
    'bf_dims'};                                                                         % number of non-zero dimensions


% put in general matrix, replace if necessary:
for in=1:numel(names)
    if ismember(names{in},beh.dec.names)
        ind               = find(ismember(beh.dec.names,names{in}));
        beh.dec.mat(:,ind)    = addmat(:,in);
    else
        beh.dec.mat(:,end+1)  = addmat(:,in);
        beh.dec.names{end+1}  = names{in};
    end
end