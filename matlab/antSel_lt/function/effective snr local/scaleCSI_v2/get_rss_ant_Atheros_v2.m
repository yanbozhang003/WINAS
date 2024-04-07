function ret = get_rss_ant_Atheros_v2(rssi)
%     error(nargchk(1,1,nargin));
    ret = rssi - 95;
    ret = double(ret);
end