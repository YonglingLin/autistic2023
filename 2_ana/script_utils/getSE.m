function [stderror] = getSE(stddata)
%this function computes the standard error; Standard error is computed by condition.
% rows must be subjects, 
% cols must be conditions. 

if sum(isnan(stddata))>0, disp('ERROR! No nans allowed.'); return; end;

[nsubj ncond]=size(stddata);
for iCond=1:ncond
    stderror(1,iCond)= std(stddata(:,iCond))./ nsubj.^.5;
end

