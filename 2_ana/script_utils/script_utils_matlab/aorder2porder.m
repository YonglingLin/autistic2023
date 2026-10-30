function [porder] = aorder2porder(ao)
% script that transforms between two ways of coding performance in relation to positions:
%
%
%
%
% aorder = [1st player, 2nd player, 3rd player, 4th player] with 1,2,3,4 in there indicating self-partner-o1-o2
% porder = [Spos, Ppos, O1pos, O2pos] = spoo_order


for ir=1:size(ao,1)
    for ia =1:4
        porder(ir,ia) = find(ao(ir,:)==ia);                                 % convert to matrix in which columns are agents: Spos-Ppos-...
    end
end



end

