function [S0,S1,S2] = beh_glm_temp_ridge_all(S0,S1,S2,doplot)


%YL, 2026

dec_S0 = S0.s.beh;
dec_S1 = S1.s.beh;
dec_S2 = S2.s.beh;

dec_all = {S0.s.beh, S1.s.beh, S2.s.beh};

n1 = numel(dec_S0);
n2 = numel(dec_S1);
n3 = numel(dec_S2);
N = [n1 n2 n3];

% for lassoglm:
for vers = 1:numel(dec_all)
      n = N(vers);
    dec = dec_all{vers};
        for is = 1:n
            tt   = gfM(dec{is}.dec,{'TT3'});
            X    = gfM(dec{is}.dec,{'pcode_xF','scode_xF','bonus'});
           
            if any(strcmp(dec{is}.dec.names, "choice"))  % for S0: lab-based dataset
                 y  = gfM(dec{is}.dec, 'choice');
            else
                 y  = gfM(dec{is}.dec,'respDM'); 
            end

            s.X{is} = X(tt==1,:);
            s.y{is} = y(tt==1);
            p.X{is} = X(tt==2,:);
            p.y{is} = y(tt==2);
   
        end

        sXverName = sprintf('s%d.X', vers); %Generate the variable name dynamically
        sYverName = sprintf('s%d.y', vers);
        pXverName = sprintf('p%d.X', vers); 
        pYverName = sprintf('p%d.y', vers);

        eval([sXverName ' = s.X']);
        eval([sYverName ' = s.y']);
        eval([pXverName ' = p.X']);
        eval([pYverName ' = p.y']);
end 


b123_sp = ridgeAll({s1.X{:} s2.X{:} s3.X{:} p1.X{:} p2.X{:} p3.X{:}}, {s1.y{:} s2.y{:} s3.y{:} p1.y{:} p2.y{:} p3.y{:}},'temp'); disp('ridge temp')

bs1 = b123_sp(1:n1,:);
bs2 = b123_sp(n1+1:(n1+n2),:);
bs3 = b123_sp(n1+n2+1:(n1+n2+n3),:);

bp1 = b123_sp([n1+n2+n3+1]:[n1+n2+n3+n1],:);
bp2 = b123_sp([n1+n2+n3+n1+1]:[n1+n2+n3+n1+n2],:);
bp3 = b123_sp([n1+n2+n3+n1+n2+1]:2*[n1+n2+n3],:);

matnames = {'Sglm-c-temp','Sglm-pcodexF','Sglm-scodexF','Sglm-bonus-temp',...
            'Pglm-c-temp','Pglm-pcodexF','Pglm-scodexF','Pglm-bonus-temp'};

% all vars
S0.tempglm.mat = [bs1 bp1];
S0.tempglm.names = matnames;

S1.tempglm.mat = [bs2 bp2];
S1.tempglm.names = matnames;

S2.tempglm.mat = [bs3 bp3];
S2.tempglm.names = matnames;

end