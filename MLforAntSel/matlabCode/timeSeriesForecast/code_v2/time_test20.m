clear;
close all
addpath('./function/');

n_tr = 1000;
n_cbn = 64;
esnr_delta = 0.3;

esnr_inUse = zeros(n_tr,1);
esnr_top = zeros(n_tr,1);
esnr_diff = zeros(n_tr,1);
for tr_idx = 1:1:n_tr
    load(['data/mat/measure1/time_tr',num2str(tr_idx+3000),'.mat']);
    
    [esnr_max,cbn_max] = max(esnr_cbn);
    esnr_top(tr_idx,1) = esnr_max;

    if tr_idx == 1
       esnr_inUse(tr_idx,1) = esnr_max;
       esnr_diff(tr_idx,1) = esnr_top(tr_idx,1) - esnr_inUse(tr_idx,1);
       first_cbn = cbn_max;
    end
    if tr_idx>1
        esnr_inUse(tr_idx,1) = esnr_cbn(first_cbn);
        
        esnr_diff(tr_idx,1) = esnr_top(tr_idx,1) - esnr_inUse(tr_idx,1);
    end
    
    disp(tr_idx);
end

figure(1)
for tr_idx = 1:1:n_tr
   
    subplot(2,1,1)
    plot(tr_idx, esnr_inUse(tr_idx,1),'k.-');hold on
    plot(tr_idx, esnr_top(tr_idx,1),'r.-');hold on
    xlim([1 n_tr]);ylim([0 180]);
    xlabel('time trace');ylabel('esnr');
    hold on
    
    subplot(2,1,2)
    plot(tr_idx, esnr_diff(tr_idx,1),'k.-');hold on
    xlim([1 n_tr]);
    xlabel('time trace');ylabel('corr');
    hold on
    
    drawnow
    
end
