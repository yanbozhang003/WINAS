
function ret = get_scaled_csi_Atheros_v2(csi_st)
    %% Pull out CSI
    csi = csi_st.csi;
    csi = permute(csi, [2 1 3]);
    csi_ant1 = csi(1,1,:);
    csi_ant2 = csi(1,2,:);
    csi_ant3 = csi(1,3,:);
    ret = zeros(1,3,56);
    
    %% 1st rx antenna CSI scale
    % Calculate the scale factor between normalized CSI and RSSI (mW)
    csi_sq_ant1 = csi_ant1 .* conj(csi_ant1);
    csi_pwr_ant1 = sum(csi_sq_ant1(:));
    rssi_pwr_ant1 = dbinv(get_rss_ant1_Atheros_v2(csi_st));
    %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
    scale_ant1 = rssi_pwr_ant1 / (csi_pwr_ant1 / 56);

    % noise floor
    thermal_noise_pwr = dbinv(-95);

    % Ret now has units of sqrt(SNR) just like H in textbooks
    ret_ant1 = csi * sqrt(scale_ant1 / thermal_noise_pwr);
    
    %% 2nd rx antenna CSI scale
    % Calculate the scale factor between normalized CSI and RSSI (mW)
    csi_sq_ant2 = csi_ant2 .* conj(csi_ant2);
    csi_pwr_ant2 = sum(csi_sq_ant2(:));
    rssi_pwr_ant2 = dbinv(get_rss_ant2_Atheros_v2(csi_st));
    %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
    scale_ant2 = rssi_pwr_ant2 / (csi_pwr_ant2 / 56);

    % noise floor
    thermal_noise_pwr = dbinv(-95);

    % Ret now has units of sqrt(SNR) just like H in textbooks
    ret_ant2 = csi * sqrt(scale_ant2 / thermal_noise_pwr);
    
    %% 3rd rx antenna CSI scale
    % Calculate the scale factor between normalized CSI and RSSI (mW)
    csi_sq_ant3 = csi_ant3 .* conj(csi_ant3);
    csi_pwr_ant3 = sum(csi_sq_ant3(:));
    rssi_pwr_ant3 = dbinv(get_rss_ant3_Atheros_v2(csi_st));
    %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
    scale_ant3 = rssi_pwr_ant3 / (csi_pwr_ant3 / 56);

    % noise floor
    thermal_noise_pwr = dbinv(-95);

    % Ret now has units of sqrt(SNR) just like H in textbooks
    ret_ant3 = csi * sqrt(scale_ant3 / thermal_noise_pwr);
    
    %% total csi
    ret(1,1,:) = ret_ant1(1,1,:);
    ret(1,2,:) = ret_ant2(1,1,:);
    ret(1,3,:) = ret_ant3(1,1,:);
end
