clear;
close all

load('./testProbing.mat');

csi_p1 = squeeze(csiBuffer.CSI(1,:,:,:));
csi_p2 = squeeze(csiBuffer.CSI(2,:,:,:));
csi_p3 = squeeze(csiBuffer.CSI(3,:,:,:));
csi_p4 = squeeze(csiBuffer.CSI(4,:,:,:));

csi_p1_db_abs = db(abs(csi_p1));
csi_p2_db_abs = db(abs(csi_p2));
csi_p3_db_abs = db(abs(csi_p3));
csi_p4_db_abs = db(abs(csi_p4));

n_tx = 3;
n_rx = 3;
cnt = 0;

for tx_idx = 1:1:n_tx
    for rx_idx = 1:1:n_rx
        cnt = cnt+1;
        csi_p1_plot = squeeze(csi_p1_db_abs(rx_idx, tx_idx,:));
        csi_p2_plot = squeeze(csi_p2_db_abs(rx_idx, tx_idx,:));
        csi_p3_plot = squeeze(csi_p3_db_abs(rx_idx, tx_idx,:));
        csi_p4_plot = squeeze(csi_p4_db_abs(rx_idx, tx_idx,:));
        
        figure(1)
%         subplot(1,4,1)
        plot(csi_p1_plot,'k.-');ylim([10 60]);hold on
        title(['tx:',num2str(tx_idx),'rx:',num2str(rx_idx)]);
%         subplot(1,4,2)
        plot(csi_p2_plot,'r.-');ylim([10 60]);hold on
        title(['tx:',num2str(tx_idx),'rx:',num2str(rx_idx)]);
%         subplot(1,4,3)
        plot(csi_p3_plot,'b.-');ylim([10 60]);hold on
        title(['tx:',num2str(tx_idx),'rx:',num2str(rx_idx)]);
%         subplot(1,4,4)
        plot(csi_p4_plot,'g.-');ylim([10 60]);hold off
        title(['tx:',num2str(tx_idx),'rx:',num2str(rx_idx)]);
                
        waitforbuttonpress()
    end
end