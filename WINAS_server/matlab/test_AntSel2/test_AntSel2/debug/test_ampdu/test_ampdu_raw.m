clear;
close all

addpath('./csi tool function/');

data = read_log_file('data/raw/ampdu_t2.txt');

save('data/mat/ampdu_t2.mat','data');