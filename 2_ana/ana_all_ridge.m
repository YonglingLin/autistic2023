% script for loading experimental and questionnaire data from jspsych logfiles, organising them, and saving them as data files
beep off;clear all; warning off;
% YL & MKW 2022

% S0: lab experiment
% S1GS: online experiment 1 and online experiment2
% S2BT: online experiment 3


% 0) define paths, set environment
addpath(genpath('script_utils')); 
addpath('script_ana');
setFigDefaults;
outdata = ['../1_data/outfrommat' filesep]; 
outdata2 = ['../1_data' filesep]; 

% 1) re-run glms with ridge methods - it will take time
%-------------------------------------------------------------------------
%[S0, S1GS, S2BT] = beh_glm_classic_ridge_all(S0, S1GS, S2BT, 0);
%[S0, S1GS, S2BT] = beh_glm_temp_ridge_all(S0, S1GS, S2BT, 0);  % rerun-basis-functions-glm
%[S0, S1GS, S2BT] = beh_glm_temp_ridge_all_splitRT(S0, S1GS, S2BT, 0);
%save([outdata2 'Alldata_4exps_ridge_' date '.mat'], 'S2BT','S1GS','S0')


% 2) load the pre-analysed data
load('../1_data/Alldata_4exps_ridge_07-Sep-2023.mat')

% 3) export data based on different experiments 

% 3a) save lab-data: S0 in different pieces: %FULLTABLE included questionnaire data is provided for the lab data in the github repo.
exportCsv([outdata 'Lab_standard_' date '_ridgeALL'], S0.cglm.mat, S0.cglm.names(1:12))
exportCsv([outdata 'Lab_tempglm_' date '_ridgeALL'], S0.tempglm.mat, S0.tempglm.names(:))
exportCsv([outdata 'Lab_temp_splitRT_' date '_ridgeALL'], S0.split_temp.mat, S0.split_temp.names(:))

% 3b) save S1GS - online 1 and online 2
S1GS.s.cglm = S1GS.cglm;
[S1GS.s.rdm.mat, S1GS.s.rdm.names]          = beh_rdm(S1GS.s.beh,0); %doplot == 1
[S1GS.s.desc.mat, S1GS.s.desc.names]        = beh_desc_s1GS(S1GS.s.beh,0);

S1GS.s.tempglm = S1GS.tempglm;
S1GS.s.split_temp = S1GS.split_temp;
[S1GS.s.rdm.mat, S1GS.s.rdm.names]          = beh_rdm(S1GS.s.beh,0); % doplot == 1
[S1GS.s.desc.mat, S1GS.s.desc.names]        = beh_desc_s1GS(S1GS.s.beh,0);

saveTable4R([outdata 'Online1_Online2_standard_' date '_ridgeALL' '.csv'], S1GS.s);


% 3c) save S2BT - online 3
S2BT.s.cglm = S2BT.cglm;
[S2BT.s.rdm.mat, S2BT.s.rdm.names]          = beh_rdm(S2BT.s.beh,0); % doplot == 1
[S2BT.s.desc.mat, S2BT.s.desc.names]        = beh_desc_s2BT(S2BT.s.beh,0);

S2BT.s.tempglm = S2BT.tempglm;
S2BT.s.split_temp = S2BT.split_temp;
[S2BT.s.rdm.mat, S2BT.s.rdm.names]          = beh_rdm(S2BT.s.beh,0); % doplot == 1
[S2BT.s.desc.mat, S2BT.s.desc.names]        = beh_desc_s2BT(S2BT.s.beh,0);

saveTable4R([outdata 'Online3_standard_' date '_ridgeALL' '.csv'], S2BT.s);
