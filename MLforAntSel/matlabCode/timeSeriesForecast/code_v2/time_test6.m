clear;
close all

n_tr = 1000;
n_cbn = 64;
n_top = 5; % save top-N

esnr_max = zeros(n_tr,n_top);
max_idx = zeros(n_tr,n_top);
esnr_mat = zeros(n_tr,n_cbn);
cbn_inUse = zeros(n_tr,1);
esnr_inUse = zeros(n_tr,1); 
for tr_idx = 1:1:n_tr
    load(['data/mat/measure1/time_tr',num2str(tr_idx),'.mat']);
    esnr_mat(tr_idx, :) = esnr_cbn;
    esnr_vec_tmp = esnr_cbn;
    esnr_vec_tmp(1:64,2) = 1:1:64;
    esnr_vec_srt = sortrows(esnr_vec_tmp,'descend');
    
    % find top5 best
    for top_i = 1:1:n_top
       esnr_max(tr_idx,top_i) = esnr_vec_srt(top_i,1);
       max_idx(tr_idx,top_i) = esnr_vec_srt(top_i,2);
    end
    
    % keep no switch if not out of top5
    max1_idx = max_idx(tr_idx,1);
    if tr_idx == 1
       cbn_inUse(tr_idx,1) = max1_idx;
       esnr_inUse(tr_idx,1) = esnr_vec_tmp(max1_idx,1);
    end
    if tr_idx>1
        max1_hist = cbn_inUse(tr_idx-1,1);
       
        if length(find(max1_hist==max_idx(tr_idx,:)))==1
            cbn_inUse(tr_idx,1) = max1_hist;
            esnr_inUse(tr_idx,1) = esnr_vec_tmp(max1_hist,1);
        else
            cbn_inUse(tr_idx,1) = max1_idx;
            esnr_inUse(tr_idx,1) = esnr_vec_tmp(max1_idx,1);
        end
    end
    
    disp(tr_idx);
end

%%
fig_config = {'k.-','c.-','b.-','g.-','r.-'};
for top_i = 1:1:1
    esnr_top = esnr_max(:,top_i);
    [f,x] = ecdf(esnr_top);
    plot(x,f,fig_config{top_i},'LineWidth',2);

    ylim([0 1]);
    hold on
end
[f,x] = ecdf(esnr_inUse);
plot(x,f,'r--','LineWidth',2.5);
hold on
for cbn_i = 1:1:n_cbn
    esnr_tmp = esnr_mat(:, cbn_i);
    [f,x] = ecdf(esnr_tmp);
    plot(x,f,'r-','LineWidth',0.5);
    ylim([0 1]);
    hold on
end