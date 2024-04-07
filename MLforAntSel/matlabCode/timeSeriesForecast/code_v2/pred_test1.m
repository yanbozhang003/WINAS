% moving average

clear;
close all

shift = 0;
pred_start = 5;

load(['./tmp/sequence/sequence_',num2str(shift),'.mat']);
seq_len = length(esnr_inUse);
    
esnr_inUse_pred = zeros(seq_len,1);

for idx = 1:1:seq_len
    if idx <= pred_start
        esnr_inUse_pred(idx,1) = esnr_inUse(idx,1);
    end
    
    if idx > pred_start
        esnr_inUse_pred(idx,1) = mean(esnr_inUse(1:(idx-1),1));
    end
    
end

figure(1)
subplot(2,1,1)
plot(esnr_top,'k.-');hold on
plot(esnr_inUse, 'r.-');hold on
plot(esnr_inUse_pred,'r.--');hold off
xlim([0 seq_len]);ylim([0 150]);
subplot(2,1,2)
plot(corr_mean,'k.-');hold on
xlim([0 seq_len]);ylim([0 1]);
