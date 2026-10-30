function [rdm,dec,buffer,exptime,trigger] = sortDecData(rawmat,logstring)
% small script to sort and organise DEC data
% MKW, Jan 2019
%%

TR = 1.2;


% load rdm specific logfile information
data.mat    = rawmat;

% get logtype identifier
data.names  = logstring.info{1};
logt = get_from_mat(data,'logtype');

% visualised RDMs including task performance
rdm.mat     = data.mat(logt==2,:);
rdm.names  = logstring.info{2} ;

% DEC performance:
dec.mat     = data.mat(logt==3,:);
dec.names   = logstring.info{3} ;

buffer.mat  = data.mat(logt==4|logt==5|logt==6,:);
buffer.names= logstring.info{4};
buffer.mat  = buffer.mat(:,1:length(buffer.names));

% get time of task performance (take RDM matrix to exclude length of start/end screens)
fbtime   = get_from_mat(buffer,'tOn');
exptime  = fbtime(end)-fbtime(1);
exptime  = round(exptime/60); 

% get MRI trigger times if specified
triCode = 7;                                                                  % 7 indicates that a trigger was recorded
if max(logt)==7 
   tri.names= logstring.info{triCode};
   tri.mat  = data.mat(logt==triCode,:);
   trigger = gfM(tri,'tOn');
   if abs(trigger(2)-trigger(1)-TR)>0.1, disp('Potential problem with trigger timing!'); end
else
   trigger = [];
end
end

