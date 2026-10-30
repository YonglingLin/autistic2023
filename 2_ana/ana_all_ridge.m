% script for loading experimental and questionnaire data from jspsych logfiles, organising them, and saving them as data files
beep off;clear all; warning off;
% YL & MKW 2022


% 0) define paths, set environment
addpath(genpath('script_utils')); 
addpath('script_ana');
setFigDefaults;
outdata = ['output_behav' filesep]; 


load('Alldata_exps_ridge_07-Sep-2023.mat')

% 4) Run glm with ridge methods
[S0, S1GS, S2BT] = beh_glm_classic_ridge_all(S0, S1GS, S2BT, 1);

save(['Alldata_ridge' date '.mat'], 'S2BT','S1GS','S0')


% 5) export data
% a) save lab-data: S0
exportCsv([outdata 'beh_cglm_S0_' date '_ridgeALL'], S0.cglm.mat, S0.cglm.names(1:12))

% b) save S1GS
S1GS.s.cglm = S1GS.cglm
[S1GS.s.rdm.mat, S1GS.s.rdm.names]          = beh_rdm(S1GS.s.beh,0); % doplot == 1
[S1GS.s.desc.mat, S1GS.s.desc.names]        = beh_desc_s1GS(S1GS.s.beh,0);
saveTable4R([outdata 's1GS_standard_' date '_ridgeALL' '.csv'], S1GS.s);

% b) save S2BT
S2BT.s.cglm = S2BT.cglm
[S2BT.s.rdm.mat, S2BT.s.rdm.names]          = beh_rdm(S2BT.s.beh,0); % doplot == 1
[S2BT.s.desc.mat, S2BT.s.desc.names]        = beh_desc_s2BT(S2BT.s.beh,0);
saveTable4R([outdata 's2BT_standard_' date '_ridgeALL' '.csv'], S2BT.s);


