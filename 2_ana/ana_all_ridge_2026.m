% script for loading experimental and questionnaire data from jspsych logfiles, organising them, and saving them as data files
beep off;clear all; warning off;
% YL & MKW 2022


% 0) define paths, set environment
addpath(genpath('script_utils')); 
addpath('script_ana');
setFigDefaults;
outdata = ['../1_data/outfrommat' filesep]; 

%load('Data/Alldata_4exps_ridge_07-Sep-2023.mat')
load('../1_data/Alldata_4exps_ridge_07-Sep-2023.mat')

% 4) Run glm with ridge methods
[S0, S1GS, S2BT] = beh_glm_classic_ridge_all(S0, S1GS, S2BT, 0);
%save(['Alldata_ridge' date '.mat'], 'S2BT','S1GS','S0')


% 5) export data
% a) save lab-data: S0
exportCsv([outdata 'beh_cglm_S0_' date '_ridgeALL'], S0.cglm.mat, S0.cglm.names(1:12))

% b) save S1GS - online 1 and online 2
 S1GS.s.cglm = S1GS.cglm
[S1GS.s.rdm.mat, S1GS.s.rdm.names]          = beh_rdm(S1GS.s.beh,0); % doplot == 1
[S1GS.s.desc.mat, S1GS.s.desc.names]        = beh_desc_s1GS(S1GS.s.beh,0);
saveTable4R([outdata 's1GS_standard_' date '_ridgeALL' '.csv'], S1GS.s);


% c) save S2BT - online 3
S2BT.s.cglm = S2BT.cglm
[S2BT.s.rdm.mat, S2BT.s.rdm.names]          = beh_rdm(S2BT.s.beh,0); % doplot == 1
[S2BT.s.desc.mat, S2BT.s.desc.names]        = beh_desc_s2BT(S2BT.s.beh,0);
saveTable4R([outdata 's2BT_standard_' date '_ridgeALL' '.csv'], S2BT.s);

%--------------------------------------------------------------------
% Add basis-functions data
%--------------------------------------------------------------------

[S0, S1GS, S2BT] = beh_glm_temp_ridge_all(S0, S1GS, S2BT, 0);
[S0, S1GS, S2BT] = beh_glm_temp_ridge_all_splitRT(S0, S1GS, S2BT, 0);

% a) lab-data: S0
exportCsv([outdata 'beh_tempglm_S0_' date '_ridgeALL'], S0.tempglm.mat, S0.tempglm.names(:))
exportCsv([outdata 'beh_temp_splitRT_S0_' date '_ridgeALL'], S0.split_temp.mat, S0.split_temp.names(:))

% b) save S1GS - online 1 & online 2
S1GS.s.tempglm = S1GS.tempglm;
S1GS.s.split_temp = S1GS.split_temp;
[S1GS.s.rdm.mat, S1GS.s.rdm.names]          = beh_rdm(S1GS.s.beh,0); % doplot == 1
[S1GS.s.desc.mat, S1GS.s.desc.names]        = beh_desc_s1GS(S1GS.s.beh,0);
saveTable4R_temp([outdata 's1GS_tempglm_' date '_ridgeALL' '.csv'], S1GS.s);

% c) save S2BT - online 3
S2BT.s.tempglm = S2BT.tempglm;
S2BT.s.split_temp = S2BT.split_temp;
[S2BT.s.rdm.mat, S2BT.s.rdm.names]          = beh_rdm(S2BT.s.beh,0); % doplot == 1
[S2BT.s.desc.mat, S2BT.s.desc.names]        = beh_desc_s2BT(S2BT.s.beh,0);
saveTable4R_temp([outdata 's2BT_tempglm_' date '_ridgeALL' '.csv'], S2BT.s);


