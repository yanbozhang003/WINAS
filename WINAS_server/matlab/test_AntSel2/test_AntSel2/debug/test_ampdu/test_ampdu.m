clear;
close all

load('data/mat/ampdu_t2.mat');

n_pkt = length(data);

tstamp_v = zeros(1,1);
ant_config = zeros(1,2);
csi_cell = cell(1,1);

for i = 1:1:n_pkt
    cnt = 0;
    tstamp_v(i) = data{i,1}.timestamp;
    
    nr = double(data{i,1}.nr);
    nc = double(data{i,1}.nc);
    
    ant_config(i,1) = nr;
    ant_config(i,2) = nc;
    
    csi = data{i,1}.csi;
    csi_cell{i,1} = csi;
    
    disp(nc);disp(nr);
    
%     if csi ~= 0
%     for nc_idx = 1:1:nc
%         for nr_idx = 1:1:nr
%             cnt = cnt+1;
%             subplot(nc,nr,cnt);
%             csi_amp_db = abs(squeeze(csi(nr_idx,nc_idx,:)));
%             plot(csi_amp_db,'k.-');
%             title(['pkt\_idx',num2str(i)]);
%         end
%     end
% %     title(['pkt_idx',num2str(i)]);
%     waitforbuttonpress();
%     end
end