clear;
close all

n_top = 5;
load(['./tmp/corrTop',num2str(n_top),'.mat']);

corr_v = corr_mat(:,1);
find_alt = find(corr_v==1);
find_alt = find_alt-1;
find_alt(1,:)=[];
alt_corr = corr_mat(find_alt,:);
alt_corr_min = min(alt_corr,[],2);
alt_corr_mean = mean(alt_corr,2);

h = histogram(alt_corr_min,100);