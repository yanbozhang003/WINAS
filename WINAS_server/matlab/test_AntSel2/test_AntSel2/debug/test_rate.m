clear;
close all

data = load('./test_rate/rate_debug.mat');
file = importdata('./test_rate/thrpt_antsel_test1.csv');

thrpt = file.data(:,2)/1000000;
thrpt_len = length(thrpt);
time_thrpt = 1:thrpt_len;

time_rate = data.dbg_timest_mat - data.dbg_timest_mat(1);

subplot(2,1,1)
plot(thrpt,'k.-');xlim([0 300]);
subplot(2,1,2)
scatter(time_rate, data.dbg_rate_mat, 'filled')