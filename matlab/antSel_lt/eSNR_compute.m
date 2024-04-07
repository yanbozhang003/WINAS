function ret = eSNR_compute(arg)

    global state;
    
    snr_offset = 0;
    
    if state == 0
        % probing state
        [n_cbn,~] = size(arg.RSSI);
        effSNR = zeros(n_cbn,8);
        uBER = zeros(n_cbn,8);
        esnr_ori = zeros(n_cbn,1);
        for cbn_idx = 1:1:n_cbn
            csi_tmp = squeeze(arg.CSI(cbn_idx,:,:,:));
            rssi_tmp = squeeze(arg.RSSI(cbn_idx,:)) + snr_offset;
            
%             disp(rssi_tmp);
            
            csi_new = permute(csi_tmp,[2 1 3]);
            csi_scaled = get_scaled_csi_Atheros_v2(csi_new,rssi_tmp);
            ber_v = get_BERs(csi_scaled);

            [uber_v,~] = uncodedBER(ber_v);
            effSNR(cbn_idx,:) = uBER2eSNR(uber_v);
            uBER(cbn_idx,:) = uber_v;
            
            esnr_tmp = get_eff_SNRs(csi_scaled);
            esnr_ori(cbn_idx,1) = esnr_tmp(7,4);
        end
        ret.eSNR = effSNR;
        ret.uBER = uBER;
        ret.tstamp = arg.tstamp;
        ret.esnr_ori = esnr_ori;
    end
    
    if state == 1
        % monitoring state
        csi_tmp = arg.CSI;
        rssi_tmp = arg.RSSI + snr_offset;
        
%         disp(rssi_tmp);
        
        csi_new = permute(csi_tmp,[2 1 3]);
        csi_scaled = get_scaled_csi_Atheros_v2(csi_new,rssi_tmp);
        ber_v = get_BERs(csi_scaled);

        [uber_v,~] = uncodedBER(ber_v);
        effSNR = uBER2eSNR(uber_v);
        
        esnr_tmp = get_eff_SNRs(csi_scaled);
        esnr_ori = esnr_tmp(7,4);
        
        ret.eSNR = effSNR';
        ret.uBER = uber_v';
        ret.tstamp = arg.tstamp;
        ret.cbnIdx = arg.cbnIdx;
        ret.esnr_ori = esnr_ori;
    end
end

