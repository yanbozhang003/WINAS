%GET_TOTAL_RSS Calculates the Received Signal Strength (RSS) in dBm from
% a CSI struct.
%
% (c) 2011 Daniel Halperin <dhalperi@cs.washington.edu>

function ret = get_total_rss_Atheros_v1(rssi)
%     error(nargchk(1,1,nargin));
    ret = rssi(4,1) - 95;
    ret = double(ret);
end

% function ret = get_total_rss(csi_st)
%     error(nargchk(1,1,nargin));
% 
%     % Careful here: rssis could be zero
%     rssi_mag = 0;
%     if csi_st.rssi1 ~= 0
%         rssi_mag = rssi_mag + dbinv(csi_st.rssi1);
%     end
%     if csi_st.rssi2 ~= 0
%         rssi_mag = rssi_mag + dbinv(csi_st.rssi2);
%     end
%     if csi_st.rssi3 ~= 0
%         rssi_mag = rssi_mag + dbinv(csi_st.rssi3);
%     end
%     
%     rssi_mag = double(rssi_mag);
%     ret = db(rssi_mag, 'power');
%     ret = ret - 95;
% end