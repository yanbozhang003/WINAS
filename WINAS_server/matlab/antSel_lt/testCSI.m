clear
close all

load('testCSI.mat');

CSI_mat = csiBuffer.CSI;
RSSI_mat = csiBuffer.RSSI;
cbn_mat = csiBuffer.cbnIdx;
tstamp  = csiBuffer.tstamp;

[n_cbn, nr, nc, nsc] = size(CSI_mat);

CSI_amp = db(abs(CSI_mat));
plt_cfg = {'k.-','b.-','r.-','g.-'};
for cbn_idx = 1:1:4
    cnt = 0;
    for rx = 1:1:3
        for tx = 1:1:3
            cnt = cnt+1;
            CSI_plt = squeeze(CSI_amp(cbn_idx,rx,tx,:));
            subplot(3,3,cnt)
            plot(CSI_plt,plt_cfg{cbn_idx});
            hold on
        end
    end
    waitforbuttonpress();
end
