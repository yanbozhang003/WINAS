addpath(genpath(pwd));

clear;

data = read_bf_file('log.all_csi.6.7.6');
for i = 1:1:length(data)
    CSI = get_scaled_csi(data{i,1});
%     total_rss = get_total_rss(data{i,1});
%     csi_scaled = get_scaled_csi(data{i,1});
%     CSI_amp = db(abs(CSI));
%     csi_scaled_amp = db(abs(csi_scaled));
%     figure
%     plot(squeeze(CSI_amp(1,1,:)),'k.-');
%     hold on
%     plot(squeeze(csi_scaled_amp(1,1,:)),'r.-');
    eff_snr = get_eff_SNRs(CSI);
end