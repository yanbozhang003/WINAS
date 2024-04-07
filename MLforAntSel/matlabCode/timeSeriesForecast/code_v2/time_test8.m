clear;
close all
addpath('./function/');

n_tr = 1000;
n_cbn = 64;
esnr_delta = 0.3;

cbn_inUse = zeros(n_tr,1);
esnr_inUse = zeros(n_tr,1);
esnr_top = zeros(n_tr,1);
esnr_mat = zeros(n_tr,n_cbn);
corr_mat = zeros(n_tr,3);
corr_mean = zeros(n_tr,1);
for tr_idx = 1:1:n_tr
    load(['data/mat/measure1/time_tr',num2str(tr_idx+5000),'.mat']);
    
    [esnr_max,cbn_max] = max(esnr_cbn);
    esnr_top(tr_idx,1) = esnr_max;
    esnr_mat(tr_idx,:) = esnr_cbn;

    if tr_idx == 1
       cbn_inUse(tr_idx,1) = cbn_max;
       esnr_inUse(tr_idx,1) = esnr_max;
       csi_ref = squeeze(csi_cbn_time(cbn_max,:,:,:));
       csi_forCorr = csi_ref;
    end
    if tr_idx>1
        cbn_hist = cbn_inUse(tr_idx-1,1);
       
        ratio = esnr_cbn(cbn_hist)/esnr_max;
        if ratio >= esnr_delta
            cbn_inUse(tr_idx,1) = cbn_hist;
            esnr_inUse(tr_idx,1) = esnr_cbn(cbn_hist,1);
            csi_forCorr = squeeze(csi_cbn_time(cbn_hist,:,:,:));
        else
            cbn_inUse(tr_idx,1) = cbn_max;
            esnr_inUse(tr_idx,1) = esnr_cbn(cbn_max,1);
            csi_ref = squeeze(csi_cbn_time(cbn_max,:,:,:));
            csi_forCorr = csi_ref;
        end
    end
    corr_mat(tr_idx,:) = calculateCorr(csi_ref, csi_forCorr);
    corr_mean(tr_idx,1) = mean(corr_mat(tr_idx,:));
    
    disp(tr_idx);
end

figure(1)
for tr_idx = 1:1:n_tr
   
    subplot(3,1,1)
    plot(tr_idx, esnr_inUse(tr_idx,1),'k.-');hold on
    plot(tr_idx, esnr_top(tr_idx,1),'r.-');hold on
    xlim([1 n_tr]);ylim([0 180]);
    xlabel('time trace');ylabel('esnr');
    hold on
    
    subplot(3,1,2)
%     plot(tr_idx, corr_mat(tr_idx,1),'k.-');hold on
%     plot(tr_idx, corr_mat(tr_idx,2),'b.-');hold on
%     plot(tr_idx, corr_mat(tr_idx,3),'r.-');hold on
    plot(tr_idx, corr_mean(tr_idx,1),'k.-');hold on
    xlim([1 n_tr]);ylim([0 1]);
    xlabel('time trace');ylabel('corr');
    hold on
    
    subplot(3,1,3)
    plot(esnr_mat(tr_idx,:),'k.-');
    xlim([1 n_cbn]);ylim([0 180]);
    
    drawnow
    
end

% figure(2)
% [f,x] = ecdf(esnr_top);
% plot(x,f,'k.-','LineWidth',2);hold on
% [f,x] = ecdf(esnr_inUse);
% plot(x,f,'b.-','LineWidth',2);hold on
% hold on
% for cbn_i = 1:1:n_cbn
%     esnr_tmp = esnr_mat(:, cbn_i);
%     [f,x] = ecdf(esnr_tmp);
%     plot(x,f,'r-','LineWidth',0.5);
%     ylim([0 1]);
%     hold on
% end
% %%
% figure(3)
% corr_v = corr_mat(:,1);
% find_alt = find(corr_v==1);
% find_alt = find_alt-1;
% find_alt(1,:)=[];
% alt_corr = corr_mat(find_alt,:);
% alt_corr_min = min(alt_corr,[],2);
% alt_corr_mean = mean(alt_corr,2);
% 
% h = histogram(alt_corr_min,10);