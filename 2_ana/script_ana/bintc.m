function [bindata,labels] = bintc(data,binsize)
% outputs means of several parts of timecourse data (corchoice, rt)
%
% INPUT: - data as nsub x ntime; ntime needs to be 96!!
%        - binsize is number that says how many trials to average together: needs to be [2 4 8 16 32]
%
%

% critical information about expected data format
ntrials = 96;
ntrain  = 1:64;
ntest   = 65:96;


% check input
if size(data,2)~=ntrials, disp('ERROR'); keyboard; end

% calculate:
nbins = ntrials/binsize;

ind     = repelem(1:nbins,1,binsize);
bincell = arrayfun(@(x) mean(data(:,ind==x),2),1:nbins,'UniformOutput',false);
bindata = cell2mat(bincell);

% get labels
labels   = {};
binmean  =  binsize/2;
while binmean < max(ntest)
    if binmean<min(ntest)
        labels{end+1} = 'train';
    else
        labels{end+1} = 'TEST';
    end
    binmean = binmean + binsize;
end






end

