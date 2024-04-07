clear;
close all

addpath('function/csi tool function with ant cbn/');

csi_struct = read_log_file('data/raw/moving_measure1.txt');

save('./tmp/moving_neasure1.mat');