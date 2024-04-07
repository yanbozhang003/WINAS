%GET_SCALED_CSI Converts a CSI struct to a channel matrix H.
%
% (c) 2008-2011 Daniel Halperin <dhalperi@cs.washington.edu>
%
function ret = get_scaled_csi_Atheros_v3(csi,rssi)
    % csi: 2x2x56
    % rssi: 1x4
    
    % Pull out CSI
%     csi = permute(csi, [2 1 3]);

    [~, n_rx, ~] = size(csi);

    if(n_rx==1)
        csi_sq = csi .* conj(csi);
        csi_pwr = sum(csi_sq(:));
        rssi_pwr = dbinv(get_total_rss_Atheros_v3(rssi(1),0));
        %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
        scale = rssi_pwr / (csi_pwr / 56);
        thermal_noise_pwr = dbinv(-95);        
        quant_error_pwr = 0;
        total_noise_pwr = thermal_noise_pwr + quant_error_pwr;
        ret = csi * sqrt(scale / total_noise_pwr);
    end
    if(n_rx==2)
        % Calculate the scale factor between normalized CSI and RSSI (mW)
        csi_sq = csi .* conj(csi);
        csi_pwr = sum(csi_sq(:));
        rssi_pwr = dbinv(get_total_rss_Atheros_v3(rssi(1),rssi(2)));
        %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
        scale = rssi_pwr / (csi_pwr / 56);

        thermal_noise_pwr = dbinv(-95);
        
        quant_error_pwr = 0;

        total_noise_pwr = thermal_noise_pwr + quant_error_pwr;

        ret = csi * sqrt(scale / total_noise_pwr);
    %     ret = csi*sqrt(scale);
    %     if csi_st.Ntx == 2
    %         ret = ret * sqrt(2);
    %     elseif csi_st.Ntx == 3
            % Note: this should be sqrt(3)~ 4.77 dB. But, 4.5 dB is how
            % Intel (and some other chip makers) approximate a factor of 3
            %
            % You may need to change this if your card does the right thing.
    %         ret = ret * sqrt(dbinv(4.5));
    %     end
    end
    
    if(n_rx==3)
        % Calculate the scale factor between normalized CSI and RSSI (mW)
        csi_sq = csi .* conj(csi);
        csi_pwr = sum(csi_sq(:));
        rssi_pwr = dbinv(get_total_rss_Atheros_v3(rssi(1),rssi(2),rssi(3)));
        %   Scale CSI -> Signal power : rssi_pwr / (mean of csi_pwr)
        scale = rssi_pwr / (csi_pwr / 56);

        thermal_noise_pwr = dbinv(-95);
        
        quant_error_pwr = 0;

        total_noise_pwr = thermal_noise_pwr + quant_error_pwr;

        ret = csi * sqrt(scale / total_noise_pwr);
    %     ret = csi*sqrt(scale);
    %     if csi_st.Ntx == 2
    %         ret = ret * sqrt(2);
    %     elseif csi_st.Ntx == 3
            % Note: this should be sqrt(3)~ 4.77 dB. But, 4.5 dB is how
            % Intel (and some other chip makers) approximate a factor of 3
            %
            % You may need to change this if your card does the right thing.
    %         ret = ret * sqrt(dbinv(4.5));
    %     end
    end
    
end
