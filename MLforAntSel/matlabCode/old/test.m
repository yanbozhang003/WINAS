clear;
% close all
addpath('./function/csi tool function/');

csi_mat = zeros(2,2,56,800,4);

for cbn_idx = 1:1:4
    filename = ['~/work/AntSel/data/0625/raw/log_RF_switch_',num2str(cbn_idx),'_TraceIndex_1.txt'];
    data = read_log_file(filename);

    n_pkt = length(data);

    for pkt_idx = 1:1:n_pkt
        csi_mat(:,:,:,pkt_idx,cbn_idx) = data{pkt_idx,1}.csi;
    end
end

ant_idx_1 = 0;
ant_idx_2 = 0;
figure(1)
for rx_CH_idx = 1:1:2
    for rx_ant_idx = 1:1:4
        ant_idx_1 = ant_idx_1 + 1;
        csi_plt = squeeze(csi_mat(rx_CH_idx,1,:,:,rx_ant_idx));
        subplot(2,4,ant_idx_1)
        plot(db(abs(csi_plt(:,1:50:800))),'k.-');
    end
end

figure(2)
for rx_CH_idx = 1:1:2
    for rx_ant_idx = 1:1:4
        ant_idx_2 = ant_idx_2 + 1;
        csi_plt = squeeze(csi_mat(rx_CH_idx,2,:,:,rx_ant_idx));
        subplot(2,4,ant_idx_2)
        plot(db(abs(csi_plt(:,1:50:800))),'k.-');
    end
end