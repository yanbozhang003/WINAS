clear;
close all

n_tr = 5000;
n_cbn = 64;
esnr_delta = 0.8;
winLen=10;
linOcc=0;

cbn_inUse = zeros(n_tr,1);
esnr_inUse = zeros(n_tr,1);
esnr_top = zeros(n_tr,1);
esnr_mat = zeros(n_tr,n_cbn);
corr_mat = zeros(n_tr,3);
corr_mean = zeros(n_tr,1);
win_idx = 1;
for tr_idx = 1:1:n_tr
    load(['data/mat/measure1/time_tr',num2str(tr_idx),'.mat']);
    
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
        
        if win_idx < winLen
            cbn_inUse(tr_idx,1) = cbn_hist;
            esnr_inUse(tr_idx,1) = esnr_cbn(cbn_hist,1);
            csi_forCorr = squeeze(csi_cbn_time(cbn_hist,:,:,:));
            win_idx = win_idx+1;
            
            corr_mat(tr_idx,:) = calculateCorr(csi_ref, csi_forCorr);
            corr_mean(tr_idx,1) = mean(corr_mat(tr_idx,:));
            disp(tr_idx);
            
            continue
        end
       
        if win_idx >= winLen
            esnr_inUse_win = esnr_inUse((tr_idx-winLen):(tr_idx-1),1);
            esnr_top_win = esnr_top((tr_idx-winLen):(tr_idx-1),1);
            
%             disp(esnr_inUse_win);
%             disp(esnr_top_win);
            
            ratio = mean(esnr_inUse_win./esnr_top_win);
            if ratio >= esnr_delta
                cbn_inUse(tr_idx,1) = cbn_hist;
                esnr_inUse(tr_idx,1) = esnr_cbn(cbn_hist,1);
                csi_forCorr = squeeze(csi_cbn_time(cbn_hist,:,:,:));
            else
                cbn_inUse(tr_idx,1) = cbn_max;
                esnr_inUse(tr_idx,1) = esnr_cbn(cbn_max,1);
                csi_ref = squeeze(csi_cbn_time(cbn_max,:,:,:));
                csi_forCorr = csi_ref;
                win_idx = 1;
            end
        end
    end
    corr_mat(tr_idx,:) = calculateCorr(csi_ref, csi_forCorr);
    corr_mean(tr_idx,1) = mean(corr_mat(tr_idx,:));
    
    disp(tr_idx);
end

% figure(1)
% subplot(2,1,1)
% scatter(1:n_tr, esnr_inUse,15,'filled','MarkerFaceColor','r');hold on
% scatter(1:n_tr, esnr_top,15,'filled','MarkerFaceColor','k');hold off
% xlim([1 n_tr]);ylim([0 180]);
% xlabel('trace idx');ylabel('esnr');
% set(gca,'FontSize',15);
% subplot(2,1,2)
% %     plot(tr_idx, corr_mat(tr_idx,1),'k.-');hold on
% %     plot(tr_idx, corr_mat(tr_idx,2),'b.-');hold on
% %     plot(tr_idx, corr_mat(tr_idx,3),'r.-');hold on
% scatter(1:n_tr, corr_mean,15,'filled','MarkerFaceColor','k');
% xlim([1 n_tr]);ylim([0 1]);
% xlabel('trace idx');ylabel('csi correlation');
% set(gca,'FontSize',15);


figure(2)
[f,x] = ecdf(esnr_top);
plot(x,f,'k.-','LineWidth',2);hold on
[f,x] = ecdf(esnr_inUse);
plot(x,f,'b.-','LineWidth',2);hold on
hold on
for cbn_i = 1:1:n_cbn
    esnr_tmp = esnr_mat(:, cbn_i);
    [f,x] = ecdf(esnr_tmp);
    plot(x,f,'r-','LineWidth',0.5);
    ylim([0 1]);
    hold on
end
%%
figure(3)
corr_v = corr_mat(:,1);
find_alt = find(corr_v==1);
find_alt = find_alt-1;
find_alt(1,:)=[];
alt_corr = corr_mat(find_alt,:);
alt_corr_min = min(alt_corr,[],2);
alt_corr_mean = mean(alt_corr,2);

h = histogram(alt_corr_mean,50);
xlim([0 1]);
xlabel('csi correlation');
ylabel('histogram');
set(gca,'FontSize',15);