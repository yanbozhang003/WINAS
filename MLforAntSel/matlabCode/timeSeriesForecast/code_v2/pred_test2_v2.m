% exponential moving average
% predict the next esnr
% multiply with the inverse of esnr's slope

clear;
close all

for shift = 0:100:5000

alpha = 0.8;
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
        ensr_win = esnr_inUse_pred((idx-start_prob+1):idx,1);
        
        p = polyfit(1:length(ensr_win),ensr_win',1);
        
%         k=0.001;
        V(idx,1) = (esnr_top_pred(idx+1,1)-esnr_inUse_pred(idx+1,1))*abs((0.1/p(1,1)));
    end
    
end

figure(1)
subplot(3,1,1)
plot(esnr_top,'k.-');hold on
plot(esnr_top_pred,'k--');hold on
plot(esnr_inUse, 'r.-');hold on
plot(esnr_inUse_pred,'r.--');hold off
xlim([0 seq_len]);ylim([0 150]);
subplot(3,1,2)
plot(V,'k.-');
xlim([0 seq_len]);
ylim([0 100]);
subplot(3,1,3)
plot(corr_mean,'k.-');
xlim([0 seq_len]);ylim([0 1]);

% figName = ['fig',num2str(shift),'.png'];
% saveas(gcf,figName);

waitforbuttonpress();
end