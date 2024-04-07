% exponential moving average
% predict the next esnr

clear;
close all

for shift = 0:100:5000

alpha = 0.5;
start_prob = 10;

load(['./tmp/sequence/sequence_',num2str(shift),'.mat']);
seq_len = length(esnr_inUse);
    
esnr_inUse_pred = zeros(seq_len,1);
esnr_top_pred = zeros(seq_len,1);
V = zeros(seq_len,1);

esnr_top_pred(1:start_prob,1) = esnr_top(1:start_prob,1);

for idx = 1:1:seq_len
    if idx == 1
        esnr_inUse_pred(idx,1) = esnr_inUse(idx,1);
        esnr_inUse_pred(idx+1,1) = alpha*esnr_inUse(idx,1)+(1-alpha)*esnr_inUse_pred(idx,1);
    end
    
    if idx > 1
        esnr_inUse_pred(idx+1,1) = alpha*esnr_inUse(idx,1)+(1-alpha)*esnr_inUse_pred(idx,1);
    end
    
    if idx >= start_prob
        esnr_top_pred(idx+1,1) = mean(esnr_top_pred(1:start_prob,1));
        corr_win = corr_mean((idx-start_prob+1):idx,1);
        
        p = polyfit(1:length(corr_win),corr_win',1);
        
%         k=0.001;
        V(idx,1) = (esnr_top_pred(idx+1,1)-esnr_inUse_pred(idx+1,1))*abs((0.001/p(1,1)));
    end
    
end

figure('Position',[0 0 1000 600])
subplot(2,1,1)
plot(esnr_top,'k.-');hold on
plot(esnr_top_pred,'k--');hold on
plot(esnr_inUse, 'r.-');hold on
plot(esnr_inUse_pred,'r.--');hold off
xlim([0 seq_len]);ylim([0 150]);
xlabel('trace idx'); ylabel('esnr');
legend('Best','Best\_pred','inUse','inUse\_pred');
set(gca, 'FontSize', 15);
% subplot(3,1,2)
% plot(V,'k.-');
% xlim([0 seq_len]);
% ylim([0 100]);
subplot(2,1,2)
plot(corr_mean,'k.-');hold off
xlim([0 seq_len]);ylim([0 1]);
xlabel('trace idx');ylabel('csi correlation');
set(gca,'FontSize',15);

% figName = ['fig',num2str(shift),'.png'];
% saveas(gcf,figName);

waitforbuttonpress();
end