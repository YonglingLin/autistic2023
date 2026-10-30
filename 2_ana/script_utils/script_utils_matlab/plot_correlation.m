function [] = plot_correlation(ps,names)
% extracts columns from the MAT results matrix, SORTED according to input 
%
% INPUT:    - ps: two parameters to correlate, cols are variables
%           - names: cell with two strings, i.e. names of parameters
% OUTPUT:   - produces a correlation plot and indicates significance
%%

% first reduce to subjects you want to have

plot(ps(:,1),ps(:,2),'ob','Linewidth',3); hold on;
% avoid nans
p1ok = find(~isnan(ps(:,1))); 
p2ok = find(~isnan(ps(:,2)));
allok = intersect(p1ok,p2ok);

regl=polyfit(ps(allok,1),ps(allok,2),1);
minval=min(ps(:,1));
maxval=max(ps(:,1));
point1=minval*regl(1)+regl(2);
point2=maxval*regl(1)+regl(2);
hline=line([minval maxval], [point1 point2]);
set(hline,'Color','r','LineWidth', 3);


[cors pvals]=corr(ps(:,1),ps(:,2),'rows','complete');
cors=diag(cors); pvals=diag(pvals);


leg=legend(['r=' num2str(round(cors*100)/100) ' (p=' num2str(round(pvals*10000)/10000)  ')']);
ylabel([ strrep(names{2},'_', ' ')],'Fontsize',12);
xlabel([ strrep(names{1},'_', ' ')],'Fontsize',12);
set(gca, 'box', 'on')




end

