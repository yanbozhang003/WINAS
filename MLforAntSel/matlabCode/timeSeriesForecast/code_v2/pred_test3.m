% exponential moving average
% predict the next esnr

clear;
close all

for shift = 100:100:5000

alpha = 0.8;
win_data = 10;
win_pred = 10;
win_Len = 30;
n = 3;
pred_cnt = 0;

load(['./tmp/sequence/sequence_',num2str(shift),'.mat']);
seq_len = length(esnr_inUse);
    
esnr_inUse_pred = zeros(seq_len,1);
esnr_top_pred = zeros(seq_len,1);
start_pred = 10;
V = zeros(seq_len,1);
line_occ=0;

esnr_top_pred(1:win_data,1) = esnr_top(1:win_data,1);
esnr_top_pred(win_data+1:seq_len+win_pred,1) = mean(esnr_top_pred(1:win_data,1));

for idx = 1:1:seq_len
%     if idx < start_pred
%         esnr_inUse_pred(idx,1) = esnr_inUse(idx,1);
%     end
    
    if idx >= start_pred
        pred_cnt = pred_cnt+1;
        if pred_cnt <= win_pred
            x = 1:1:idx;
            y = esnr_inUse(x,1)';
            p = polyfit(x,y,n);
            x_pred = (idx+1):1:(idx+1+(pred_cnt-1));
            y_pred = polyval(p,x_pred);
        else
%             x = (idx-win_data-win_pred+2):1:idx;
            if idx <= win_Len
                x = 1:1:idx;
            else
                x = (idx-win_Len+1):1:idx;
            end
            y = esnr_inUse(x,1)';
            p = polyfit(x,y,n);
            x_pred = (idx+1):1:(idx+1+(win_pred-1));
            y_pred = polyval(p,x_pred);
        end
        disp(x);
        disp(x_pred);
        figure(1)
        plot(esnr_top,'k.-');hold on
        plot(esnr_inUse,'r.-');hold on
        plot(x_pred,y_pred,'b.--');hold off
        waitforbuttonpress();
        
        V(idx,1) = mean(esnr_top_pred(x_pred,1)'-y_pred);
    end
    
%     if idx >= win_data
%         esnr_top_pred(idx+1,1) = mean(esnr_top_pred(1:win_data,1));
%         corr_win = corr_mean((idx-win_data+1):idx,1);
%         
%         p = polyfit(1:length(corr_win),corr_win',1);
%         
% %         k=0.001;
%         V(idx,1) = (esnr_top_pred(idx+1,1)-esnr_inUse_pred(idx+1,1))*abs((0.001/p(1,1)));
%     end
end

figure(1)
subplot(3,1,1)
plot(esnr_top,'k.-');hold on
plot(esnr_top_pred,'k--');hold on
plot(esnr_inUse, 'r.-');hold off
% plot(esnr_inUse_pred,'r.--');hold off
xlim([0 seq_len]);ylim([0 150]);
subplot(3,1,2)
plot(V,'k.-');
xlim([0 seq_len]);
ylim([0 150]);
subplot(3,1,3)
plot(corr_mean,'k.-');
xlim([0 seq_len]);ylim([0 1]);

% figName = ['fig',num2str(shift),'.png'];
% saveas(gcf,figName);

waitforbuttonpress();
end