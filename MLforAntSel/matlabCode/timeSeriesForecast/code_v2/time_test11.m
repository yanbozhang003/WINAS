clear;
close all

n_tr = 100;
n_cbn = 64;
% tr_shift = 501;

esnr_top = zeros(n_tr,1);
esnr_mat = zeros(n_tr,n_cbn);
esnr_inUse = zeros(n_tr,1);
corr_mat = zeros(n_tr,3);
corr_mean = zeros(n_tr,1);

for tr_shift = 0:100:6000
for tr_idx = 1:1:n_tr
    load(['data/mat/measure1/time_tr',num2str(tr_idx+tr_shift),'.mat']);
    
    [esnr_max,cbn_max] = max(esnr_cbn);
    esnr_top(tr_idx,1) = esnr_max;
    esnr_mat(tr_idx,:) = esnr_cbn;
    
    if tr_idx == 1
        cbn_tr1 = cbn_max;
        esnr_inUse(tr_idx,1) = esnr_cbn(cbn_max,1);
        csi_ref = squeeze(csi_cbn_time(cbn_tr1,:,:,:));
        csi_inUse = csi_ref;
        line_occ=0;
    end

    if tr_idx > 1
        esnr_inUse(tr_idx,1) = esnr_cbn(cbn_tr1,1);
        csi_inUse = squeeze(csi_cbn_time(cbn_tr1,:,:,:));
    end
        
    corr_mat(tr_idx,:) = calculateCorr(csi_ref, csi_inUse);
    corr_mean(tr_idx,1) = mean(corr_mat(tr_idx,:));
    
    disp(tr_idx);
end

% figure(1)
% for tr_idx = 1:1:n_tr
%     
%     subplot(2,1,1)
%     plot(tr_idx, esnr_top(tr_idx,1),'k.-');hold on
%     plot(tr_idx, esnr_inUse(tr_idx,1),'r.-');hold on
%     xlim([0 n_tr]);ylim([0 150]);
%     subplot(2,1,2)
%     plot(tr_idx, corr_mean(tr_idx,1),'k.-');hold on
%     xlim([0 n_tr]);ylim([0 1]);
%     
% end

% fig_name = ['fig_',num2str(tr_shift),'.png'];
% savefig('./tmp/fig/fig_name');

% fileName = ['./tmp/sequence/sequence_',num2str(tr_shift),'.mat'];
% save(fileName,'esnr_top','esnr_inUse','corr_mean');

end