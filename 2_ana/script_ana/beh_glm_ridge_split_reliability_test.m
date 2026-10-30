function  beh_glm_ridge_split_reliability_test(dec)
% extract the variables that apply to split-half reliabiity
% 
% YL 2023
%%

opath = 'Data/';

n = numel(dec);
for is = 1:n
            y      =    gfM(dec{is}.dec,'respDM');
            tt     =    gfM(dec{is}.dec,'TT3');         % trial type; 1 = self, 2= partner
          SPOrOi   =    gfM(dec{is}.dec,{'S','P','Or','Oi','bonus'});
          bonus    =    gfM(dec{is}.dec,{'bonus'});

    % 1) perform the classic GLM
          cs.X{is} = SPOrOi(tt==1,:);
          cs.y{is} = y(tt==1);
          cp.X{is} = SPOrOi(tt==2,:);
          cp.y{is} = y(tt==2);

    % 2) calculate group drive and individual drive:
      groupd       =      SPOrOi(:,1) +  SPOrOi(:,2)    -  SPOrOi(:,3)    -  SPOrOi(:,4);
    indiv(tt==1)   =  SPOrOi(tt==1,1) - SPOrOi(tt==1,2) - SPOrOi(tt==1,3) + SPOrOi(tt==1,4);
    indiv(tt==2)   = -SPOrOi(tt==2,1) + SPOrOi(tt==2,2) - SPOrOi(tt==2,3) + SPOrOi(tt==2,4);
       Xalt        = [groupd indiv' bonus]; 

          ts.X{is}  = Xalt(tt==1,:);
          ts.y{is}  = y(tt==1);
          tp.X{is}  = Xalt(tt==2,:);
          tp.y{is}  = y(tt==2);
end


%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

Testnr = 3;
for Tnr = 1:Testnr
    for isub = 1: n
        tlnr    = size(ts.X{isub},1);
        out     = randperm(tlnr);
        out_1   = out(1:tlnr/2); 
        out_2   = out(tlnr/2+1:end);

 % 1) classicGLM:
        % first half
        cs1.X{isub} = cs.X{isub}(out_1,:);
        cs1.y{isub} = cs.y{isub}(out_1,:);
        cp1.X{isub} = cp.X{isub}(out_1,:);
        cp1.y{isub} = cp.y{isub}(out_1,:);
        
        % second half
        cs2.X{isub} = cs.X{isub}(out_2,:); 
        cs2.y{isub} = cs.y{isub}(out_2,:);
        cp2.X{isub} = cp.X{isub}(out_2,:); 
        cp2.y{isub} = cp.y{isub}(out_2,:);


 % 2) groupDrive and indiviDrive:       
        % first half
        ts1.X{isub} = ts.X{isub}(out_1,:); 
        ts1.y{isub} = ts.y{isub}(out_1,:);
        tp1.X{isub} = tp.X{isub}(out_1,:); 
        tp1.y{isub} = tp.y{isub}(out_1,:); 
    
        % second half
        ts2.X{isub} = ts.X{isub}(out_2,:); 
        ts2.y{isub} = ts.y{isub}(out_2,:);
        tp2.X{isub} = tp.X{isub}(out_2,:); 
        tp2.y{isub} = tp.y{isub}(out_2,:); 
    end


% do the ridge in two subsets in classicGLM
bcs1 = ridgeAll(cs1.X,cs1.y,'selfclassic');    disp('ridge self')
bcp1 = ridgeAll(cp1.X,cp1.y,'partnerclassic'); disp('ridge partner')

bcs2 = ridgeAll(cs2.X,cs2.y,'selfclassic');    disp('ridge self')
bcp2 = ridgeAll(cp2.X,cp2.y,'partnerclassic'); disp('ridge partner')

cmat = [bcs1(:,2) bcs1(:,4) bcp1(:,3) bcp1(:,4) bcs2(:,2) bcs2(:,4) bcp2(:,3) bcp2(:,4)];
cmatnames = {'cS1glm-S','cS1glm-Or','cP1glm-P','cP1glm-Or','cS2glm-S','cS2glm-Or','cP2glm-P','cP2glm-Or'};

T = array2table(cmat, 'VariableNames', cmatnames);
writetable([T], [opath  'classic_SplitHalf' '_' num2str(Tnr) '_' date '.csv'])

%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
% do the ridge in two subsets in tempGLM
bs1 = ridgeAll(ts1.X,ts1.y,'selftemp');    disp('ridge self')
bp1 = ridgeAll(tp1.X,tp1.y,'partnertemp'); disp('ridge partner')

bs2 = ridgeAll(ts2.X,ts2.y,'selftemp');    disp('ridge self')
bp2 = ridgeAll(tp2.X,tp2.y,'partnertemp'); disp('ridge partner')

% define the GroupMergence in subset1 and subset2
SgroupMerg1 = bs1(:,2) - bs1(:,3); % S1temp_groupdri - S1temp_individri
SgroupMerg2 = bs2(:,2) - bs2(:,3); % S2temp_groupdri - S2temp_individri

PgroupMerg1 = bp1(:,2) - bp1(:,3); % groupdri - individri in Partner_1 trial
PgroupMerg2 = bp2(:,2) - bp2(:,3); % groupdri - individri in Partner_2 trial

tmat = [SgroupMerg1 SgroupMerg2 PgroupMerg1 PgroupMerg2];
tmatnames = {'SgroupMerg1','SgroupMerg2','PgroupMerg1','PgroupMerg2'}; 

T2 = array2table(tmat, 'VariableNames', tmatnames);
writetable([T2], [opath 'temp_SplitHalf' '_' num2str(Tnr) '_' date '.csv'])


end

end

