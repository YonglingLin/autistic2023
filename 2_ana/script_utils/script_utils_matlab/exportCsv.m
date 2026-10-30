function [outputArg1,outputArg2] = exportCsv(filename,m,vnames)
% quick script to export matrices
% MKW Sep 2018
%
% INPUT:    - fname: filename (including path)
%           - m: subject/session x variable matrix
%           - vnames: variable names inputted as cell
%
%%

filename = [filename '.csv'];

header_string = vnames{1};
for i = 2:length(vnames)
    header_string = [header_string,',',vnames{i}];
end

%write the string to a file
fid = fopen(filename,'w');
fprintf(fid,'%s\r\n',header_string);
fclose(fid);

% Call dlmwrite with a comma as the delimiter
dlmwrite(filename, m,'-append','delimiter',',');

disp(['exporting ' filename])

end

