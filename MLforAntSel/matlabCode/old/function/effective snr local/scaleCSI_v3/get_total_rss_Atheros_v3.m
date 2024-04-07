%GET_TOTAL_RSS Calculates the Received Signal Strength (RSS) in dBm from
% a CSI struct.
%
% (c) 2011 Daniel Halperin <dhalperi@cs.washington.edu>

function ret = get_total_rss_Atheros_v3(rssi_1,rssi_2)
% %     error(nargchk(1,1,nargin));
%     ret = rssi(4,1) - 95;
%     ret = double(ret);
% end

% function ret = get_total_rss(csi_st)
%     error(nargchk(1,1,nargin));
% 
    % Careful here: rssis could be zero
    rssi_mag = 0;
    if rssi_1 ~= 0
        rssi_mag = rssi_mag + dbinv(rssi_1);
    end
    if rssi_2 ~= 0
        rssi_mag = rssi_mag + dbinv(rssi_2);
    end
    
    rssi_mag = double(rssi_mag);
    ret = db(rssi_mag, 'power');
    ret = ret - 95;
end