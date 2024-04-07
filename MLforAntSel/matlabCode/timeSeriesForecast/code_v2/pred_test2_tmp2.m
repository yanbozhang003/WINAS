% exponential moving average
% predict the next esnr

clear;
close all

corr_v = zeros(length(0:100:5000),1);
cnt = 0;
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

esnr_diff = esnr_inUse ./ esnr_top;
esnr_diff_s = zeros(length(esnr_diff),1);

% smooth esnr_diff
alpha_1 = 0.5;
for i = 1:1:seq_len
    if i == 1
        esnr_diff_s(i,1) = esnr_diff(i,1);
    else
        esnr_diff_s(i,1) = alpha_1 * esnr_diff(i,1) + (1-alpha_1) * esnr_diff_s(i-1,1);
    end
end

corr = corrcoef(esnr_diff_s, corr_mean);

cnt = cnt+1;
corr_v(cnt,1) = abs(corr(2,1));
end

[f,x] = ecdf(corr_v);
plot(x,f,'r.-')