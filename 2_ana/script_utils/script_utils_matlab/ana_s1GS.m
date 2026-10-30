% script for loading experimental and questionnaire data from jspsych logfiles, organising them, and saving them as data files
beep off;clear all; warning off;
% YL & MKW 2022



% -1) define paths, set environment
addpath(genpath('script_utils')); 
addpath('script_ana');
setFigDefaults;

load('s_19-Apr-2023.mat')

%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

% 1) calculate variables of interest and add them to our data
for is =1:numel(s.beh) 
   s.beh{is}.dec  = add2dec(s.beh{is},[1 1 1 1]);
   s.beh{is}      = addTempFun(s.beh{is});  
end

%keyboard
s = filterSubs(s,1);    close all;                                                       % apply exclusion criteria
s = findMatchedTrials(s);                                                       % find dyadic trials that are the same in group and nogroup conditions


%beh_desc(s.beh,1)
beh_glm_classic(s.beh,1)
%beh_glm_temp(s.beh,1)



% flip analysis:
%beh_glm_tempsubtle(s.beh); 


