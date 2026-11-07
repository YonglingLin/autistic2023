function colout = sC(name)
% quick script for setting colours for s2BT study, based on schedule names
% MKW 2023

cmap= cbrewer('qual','Paired',10);

if strcmp(name,'w5w8')
    colout = cmap(4,:);
elseif strcmp(name,'w5w7')
    colout = cmap(3,:);
elseif strcmp(name,'w6w8')
    colout = cmap(9,:);
elseif strcmp(name,'w6w7')
    colout = cmap(10,:);
end



