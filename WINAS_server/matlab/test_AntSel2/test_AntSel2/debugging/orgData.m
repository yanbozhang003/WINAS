% prepare a static trace to debug the system
% first packet used for searching state, ant_cbn = 1,22,43,64
% the following packets are for any fixed ant_cbn
% set a variable to adjust the frame interval, equal to different moving
% speed. 
% with this trace, the least interval can be around 8ms with moving speed
% 0.1m/s, so the least distance can be 8mm. 

clear;
close all

load('moving_measure1.mat');
n_pkt = length(csi_struct);

tstamp_v = zeros(n_pkt,1);
data_dbg = cell(1,1);
cnt = 0;
for pkt_idx = 1:1:n_pkt
    tstamp = csi_struct{pkt_idx}.timestamp;
    
    if pkt_idx<=4
        cnt = cnt+1;
        data_dbg{pkt_idx,1} = csi_struct{pkt_idx,1};
    else
        f = mod(pkt_idx,4);
        if f==1
            cnt = cnt+1;
            data_dbg{cnt,1} = csi_struct{pkt_idx,1};
        end
    end
end

% check the ant_cbn
cbn_v = zeros(length(data_dbg),1);
for i = 1:1:length(data_dbg)
    disp(i);
    cbn_v(i) = data_dbg{i,1}.ant_cbn;
end
plot(cbn_v)

save('data_dbg.mat','data_dbg');