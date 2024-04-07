
function ret = get_scaled_csi_Atheros_v2(csi, rssi)
    %% Pull out CSI
%     csi = csi_st.csi;
%     csi = permute(csi, [2 1 3]);
    [~, n_rx, ~] = size(csi);
    
    if(n_rx==1)
        csi_RxAnt1 = squeeze(csi(:,:,:));
        ret = zeros(1,1,56);
        
        csi_sq_ant1 = csi_RxAnt1 .* conj(csi_RxAnt1);
        csi_pwr_ant1 = sum(csi_sq_ant1(:));
        rssi_pwr_ant1 = dbinv(get_rss_ant_Atheros_v2(rssi(1)));
        %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
        scale_ant1 = rssi_pwr_ant1 / (csi_pwr_ant1 / 56);

        % noise floor
        thermal_noise_pwr = dbinv(-95);

        % Ret now has units of sqrt(SNR) just like H in textbooks
        ret(1,1,:) = csi_RxAnt1 * sqrt(scale_ant1 / thermal_noise_pwr);
    end
    
    if(n_rx==2)
        csi_RxAnt1 = csi(:,1,:);
        csi_RxAnt2 = csi(:,2,:);
        ret = zeros(2,2,56);

        % 1st rx antenna CSI scale
        % Calculate the scale factor between normalized CSI and RSSI (mW)
        csi_sq_ant1 = csi_RxAnt1 .* conj(csi_RxAnt1);
        csi_pwr_ant1 = sum(csi_sq_ant1(:));
        rssi_pwr_ant1 = dbinv(get_rss_ant_Atheros_v2(rssi(1)));
        %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
        scale_ant1 = rssi_pwr_ant1 / (csi_pwr_ant1 / 56);

        % noise floor
        thermal_noise_pwr = dbinv(-95);

        % Ret now has units of sqrt(SNR) just like H in textbooks
        ret_ant1 = csi_RxAnt1 * sqrt(scale_ant1 / thermal_noise_pwr);

        % 2nd rx antenna CSI scale
        % Calculate the scale factor between normalized CSI and RSSI (mW)
        csi_sq_ant2 = csi_RxAnt2 .* conj(csi_RxAnt2);
        csi_pwr_ant2 = sum(csi_sq_ant2(:));
        rssi_pwr_ant2 = dbinv(get_rss_ant_Atheros_v2(rssi(2)));
        %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
        scale_ant2 = rssi_pwr_ant2 / (csi_pwr_ant2 / 56);

        % noise floor
        thermal_noise_pwr = dbinv(-95);

        % Ret now has units of sqrt(SNR) just like H in textbooks
        ret_ant2 = csi_RxAnt2 * sqrt(scale_ant2 / thermal_noise_pwr);

        % total csi
        ret(:,1,:) = ret_ant1;
        ret(:,2,:) = ret_ant2;
    end
    
    if(n_rx==3)
        csi_RxAnt1 = csi(:,1,:);
        csi_RxAnt2 = csi(:,2,:);
        csi_RxAnt3 = csi(:,3,:);
        ret = zeros(3,3,56);

        % 1st rx antenna CSI scale
        % Calculate the scale factor between normalized CSI and RSSI (mW)
        csi_sq_ant1 = csi_RxAnt1 .* conj(csi_RxAnt1);
        csi_pwr_ant1 = sum(csi_sq_ant1(:));
        rssi_pwr_ant1 = dbinv(get_rss_ant_Atheros_v2(rssi(1)));
        %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
        scale_ant1 = rssi_pwr_ant1 / (csi_pwr_ant1 / 56);

        % noise floor
        thermal_noise_pwr = dbinv(-95);

        % Ret now has units of sqrt(SNR) just like H in textbooks
        ret_ant1 = csi_RxAnt1 * sqrt(scale_ant1 / thermal_noise_pwr);

        % 2nd rx antenna CSI scale
        % Calculate the scale factor between normalized CSI and RSSI (mW)
        csi_sq_ant2 = csi_RxAnt2 .* conj(csi_RxAnt2);
        csi_pwr_ant2 = sum(csi_sq_ant2(:));
        rssi_pwr_ant2 = dbinv(get_rss_ant_Atheros_v2(rssi(2)));
        %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
        scale_ant2 = rssi_pwr_ant2 / (csi_pwr_ant2 / 56);

        % noise floor
        thermal_noise_pwr = dbinv(-95);

        % Ret now has units of sqrt(SNR) just like H in textbooks
        ret_ant2 = csi_RxAnt2 * sqrt(scale_ant2 / thermal_noise_pwr);

        % 3rd rx antenna CSI scale
        % Calculate the scale factor between normalized CSI and RSSI (mW)
        csi_sq_ant3 = csi_RxAnt3 .* conj(csi_RxAnt3);
        csi_pwr_ant3 = sum(csi_sq_ant3(:));
        rssi_pwr_ant3 = dbinv(get_rss_ant_Atheros_v2(rssi(3)));
        %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
        scale_ant3 = rssi_pwr_ant3 / (csi_pwr_ant3 / 56);

        % noise floor
        thermal_noise_pwr = dbinv(-95);

        % Ret now has units of sqrt(SNR) just like H in textbooks
        ret_ant3 = csi_RxAnt3 * sqrt(scale_ant3 / thermal_noise_pwr);
        
        % total csi
        ret(:,1,:) = ret_ant1;
        ret(:,2,:) = ret_ant2;
        ret(:,3,:) = ret_ant3;
    end
end
