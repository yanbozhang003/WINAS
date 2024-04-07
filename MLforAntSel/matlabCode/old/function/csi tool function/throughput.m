
%%
data = read_log_file('../data/tst1')

% calculate the throughput
thp = zeros(100,1);
thp(1,1) = data{1,1}.payload_len*8000/(data{2,1}.timestamp-data{1,1}.timestamp);
for i = 2: 1: 100
    thp(i,1) = data{i,1}.payload_len*8000/(data{i,1}.timestamp-data{i-1,1}.timestamp);
end

% set the time window
time = zeros(100,1);
for j = 1: 1: 100
    time(j,1) = j/10;
end

thp_plot = plot(time,thp);
hold on
ylim([50 100]);
xlabel('time(s)');
ylabel('Throughput(kbit/s)');
title('Throughput Test');
thp_plot.Color = 'red';
thp_plot.LineWidth = 1;

%% RF1
data = read_log_file('../data/tst2')

% calculate the throughput
thp = zeros(100,1);
thp(1,1) = data{1,1}.payload_len*8000/(data{2,1}.timestamp-data{1,1}.timestamp);
for i = 2: 1: 100
    thp(i,1) = data{i,1}.payload_len*8000/(data{i,1}.timestamp-data{i-1,1}.timestamp);
end

% set the time window
time = zeros(100,1);
for j = 1: 1: 100
    time(j,1) = j/10;
end

thp_plot = plot(time,thp);
ylim([50 100]);
xlabel('time(s)');
ylabel('Throughput(kbit/s)');
title('Throughput Test');
thp_plot.Color = 'blue';
thp_plot.LineWidth = 1;

% %% RF2
% data = read_log_file('../data/tst3')
% 
% % calculate the throughput
% thp = zeros(100,1);
% thp(1,1) = data{1,1}.payload_len*8000/(data{2,1}.timestamp-data{1,1}.timestamp);
% for i = 2: 1: 100
%     thp(i,1) = data{i,1}.payload_len*8000/(data{i,1}.timestamp-data{i-1,1}.timestamp);
% end
% 
% % set the time window
% time = zeros(100,1);
% for j = 1: 1: 100
%     time(j,1) = j/10;
% end
% 
% thp_plot = plot(time,thp);
% ylim([50 100]);
% xlabel('time(s)');
% ylabel('Throughput(kbit/s)');
% title('Throughput Test');
% thp_plot.Color = 'blue';
% thp_plot.LineWidth = 1;
% 
% %% RF3
% data = read_log_file('../data/tst4')
% 
% % calculate the throughput
% thp = zeros(100,1);
% thp(1,1) = data{1,1}.payload_len*8000/(data{2,1}.timestamp-data{1,1}.timestamp);
% for i = 2: 1: 100
%     thp(i,1) = data{i,1}.payload_len*8000/(data{i,1}.timestamp-data{i-1,1}.timestamp);
% end
% 
% % set the time window
% time = zeros(100,1);
% for j = 1: 1: 100
%     time(j,1) = j/10;
% end
% 
% thp_plot = plot(time,thp);
% ylim([50 100]);
% xlabel('time(s)');
% ylabel('Throughput(kbit/s)');
% title('Throughput Test');
% thp_plot.Color = 'blue';
% thp_plot.LineWidth = 1;
% 
% %% RF4
% data = read_log_file('../data/tst5')
% 
% % calculate the throughput
% thp = zeros(100,1);
% thp(1,1) = data{1,1}.payload_len*8000/(data{2,1}.timestamp-data{1,1}.timestamp);
% for i = 2: 1: 100
%     thp(i,1) = data{i,1}.payload_len*8000/(data{i,1}.timestamp-data{i-1,1}.timestamp);
% end
% 
% % set the time window
% time = zeros(100,1);
% for j = 1: 1: 100
%     time(j,1) = j/10;
% end
% 
% thp_plot = plot(time,thp);
% ylim([50 100]);
% xlabel('time(s)');
% ylabel('Throughput(kbit/s)');
% title('Throughput Test');
% thp_plot.Color = 'blue';
% thp_plot.LineWidth = 1;
