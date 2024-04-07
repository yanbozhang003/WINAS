clear;
close all
addpath('./function/')

n_tr = 1000;
n_top = 5;

ant_mat = zeros(3,n_tr);
esnr_mat = zeros(n_tr,64);
max_idx = zeros(n_tr,n_top); % top5
cbn_inUse = zeros(n_tr,1);
corr_mat = zeros(n_tr,3); % 3 receiving antennas

for tr_idx = 1:1:n_tr
   load(['data/mat/measure1/time_tr',num2str(tr_idx),'.mat']);
   esnr_vec_tmp = esnr_cbn;
   esnr_mat(tr_idx,:) = esnr_cbn;
   esnr_vec_tmp(1:64,2) = 1:1:64;
   esnr_vec_srt = sortrows(esnr_vec_tmp,'descend');
   
   % find top5 best
   for top_i = 1:1:n_top
       max_idx(tr_idx,top_i) = esnr_vec_srt(top_i,2);
   end

   max1_idx = max_idx(tr_idx,1);
   if tr_idx == 1
       cbn_inUse(tr_idx,1) = max1_idx;
       csi_ref = squeeze(csi_cbn_time(max1_idx,:,:,:));
       csi_forCorr = csi_ref;
   end
   if tr_idx>1
       max1_hist = cbn_inUse(tr_idx-1,1);
       
       if length(find(max1_hist==max_idx(tr_idx,:)))==1
           cbn_inUse(tr_idx,1) = max1_hist;
           csi_forCorr = squeeze(csi_cbn_time(max1_hist,:,:,:));
       else
           cbn_inUse(tr_idx,1) = max1_idx;
           csi_ref = squeeze(csi_cbn_time(max1_idx,:,:,:));
           csi_forCorr = csi_ref;
       end
   end
   
   corr_mat(tr_idx,:) = calculateCorr(csi_ref, csi_forCorr);
   
   % map top1 to antenna
   Ch3_rf = mod((cbn_inUse(tr_idx,1)-1),4)+1;
   tmp = floor((cbn_inUse(tr_idx,1)-1)/4);
   Ch2_rf = mod(tmp,4)+1;
   tmp = floor(tmp/4);
   Ch1_rf = mod(tmp,4)+1;
   
   ant_mat(1,tr_idx) = Ch1_rf;
   ant_mat(2,tr_idx) = Ch2_rf;
   ant_mat(3,tr_idx) = Ch3_rf;
   
   disp(tr_idx);
end
% save(['./tmp/corrTop',num2str(n_top),'.mat'],'corr_mat');
for tr_idx = 1:1:n_tr
    esnr_ref = esnr_mat(1,:);
    esnr_tmp = esnr_mat(tr_idx,:);
    
    corr_esnr = corrcoef(esnr_ref,esnr_tmp);
    corr_esnr = abs(corr_esnr(2,1));
    
    figure(1)
%     subplot(3,1,1)
%     plot(tr_idx, max_idx(tr_idx,1),'k.-');hold on
%     xlim([1 n_tr]);ylim([1 64]);
    subplot(3,1,1)
    plot(tr_idx, cbn_inUse(tr_idx,1),'r.-');hold on
%     plot(tr_idx, max_idx(tr_idx,2),'r.-');hold on
%     plot(tr_idx, max_idx(tr_idx,3),'b.-');hold on
    xlim([1 n_tr]);ylim([1 64]);
    subplot(3,1,2)
    plot(tr_idx, corr_mat(tr_idx,1),'k.-');hold on
    plot(tr_idx, corr_mat(tr_idx,2),'b.-');hold on
    plot(tr_idx, corr_mat(tr_idx,3),'r.-');hold on
%     plot(tr_idx, mean(corr_mat(tr_idx,:)),'k.-');hold on
    xlim([1 n_tr]);ylim([0 1]);
%     subplot(6,1,3)
%     plot(tr_idx, ant_mat(1,tr_idx),'k.-');hold on
%     xlim([1 n_tr]);ylim([1 4]);
%     subplot(6,1,4)
%     plot(tr_idx, ant_mat(2,tr_idx),'b.-');hold on
%     xlim([1 n_tr]);ylim([1 4]);
%     subplot(6,1,5)
%     plot(tr_idx, ant_mat(3,tr_idx),'r.-');hold on
%     xlim([1 n_tr]);ylim([1 4]);
    subplot(3,1,3)
%     plot(tr_idx, corr_esnr, 'k.-');
%     xlim([1 n_tr]);ylim([0 1]); hold on
%     title('esnr corr');
    plot(esnr_tmp,'k.-');
    xlim([1 64]); ylim([0 180]);
%     subplot(3,1,3)
    
    drawnow;
%     waitforbuttonpress;
end

figure(2)
subplot(3,1,1)
plot(ant_mat(1,:),'k.-');ylim([1 4]);
subplot(3,1,2)
plot(ant_mat(2,:),'k.-');ylim([1 4]);
subplot(3,1,3)
plot(ant_mat(3,:),'k.-');ylim([1 4]);


