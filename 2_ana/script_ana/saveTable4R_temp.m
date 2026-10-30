function  saveTable4R_temp( fname,DATA)
% saves all relevant behavioural and questionnaire data to a table for analysis in R:
     % make sure every column name is unqiue and clear enough to find the variable in the very big table!

% YL and MKW, 2022
%%

% 1) ids
Tid = [];
for is = 1:length(DATA.beh)
    Tid = [Tid ; DATA.beh{is}.ids]; % note that in here are some variable names that will be confusing in the very big table, like "accuracy" - because this accuracy only refers to the catch questions re the experiment
end

% 2) rdm
Trdm  = array2table(DATA.rdm.mat,'VariableNames', DATA.rdm.names);

% 3) descriptive results from DM part;
Tdesc = array2table(DATA.desc.mat, 'VariableNames',DATA.desc.names);

% 4) glm_classic 
%Tglm  = array2table(DATA.cglm.mat,'VariableNames', DATA.cglm.names);

% 5) temp
Ttemp  = array2table(DATA.tempglm.mat,'VariableNames', DATA.tempglm.names);

Ttemp_splitRT  = array2table(DATA.split_temp.mat,'VariableNames', DATA.split_temp.names);

% 6) questionnaire summary scores
Qmat = [];
for is = 1:length(DATA.beh)
    Qmat(is,:) = DATA.beh{is}.qns.mat;
end
Tq = array2table(Qmat,'VariableNames', DATA.beh{1}.qns.names); % note that the {1} as index is only ok here if all names are the same always for all participants

% 7) Wokerscomments
 Workercomments = {};
 for is = 1:length(DATA.beh)
     Workercomments{is,1} = DATA.beh{is}.Workercomments;
 end
 Tcomments= cell2table(Workercomments);

% Make tables for all the stuff you want, and save: 
T = [Tid, Tdesc, Ttemp, Ttemp_splitRT, Tq];  %Ttemp, Tglm,  Trdm, Tcomments

writetable(T,fname); 


end

