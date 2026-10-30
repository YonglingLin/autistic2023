function [outputArg1,outputArg2] = visRidge(bs,DS,lspace,lam)
% visualise effects from ridge regression for groucial project
%
% MKW, Nov 2020

% some calculations
[devS,indlamS] = min(mean(DS));
lamS  = lspace(indlamS);


% Plot1: Plot the crossvalidated model fit over lambda 
subplot(2,2,1);
p1= semilogx(lspace,mean(DS)'); cs = get(p1,'Color'); hold all;
semilogx(lspace,mean([DS;])','k','Linewidth',3); 
plot(lamS,devS,'or','Linewidth',3); 
hl = line([lam lam],ylim); set(hl,'Color','r','LineStyle','--'); hold all;
xlabel('lambda');
ylabel('deviance');
setfp(gca);


% Plot2: plot beta traces over lambda for lambda space information - plot it twice, on big and small scale
subplot(2,2,3);
semilogx(lspace,squeeze(mean(bs(:,2:end,:),1))','Color',cs); hold all
xlabel('lambda'); 
ylabel('betas w/out b0'); 
title(['B1s over lambda (best Lambda = ' num2str(lam) ')']);
hl = line([lam lam],ylim); set(hl,'Color','r','LineStyle','--'); hold all;setfp(gca);
setfp(gca);

end

