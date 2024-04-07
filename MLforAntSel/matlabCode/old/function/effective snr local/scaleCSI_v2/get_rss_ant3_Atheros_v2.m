function ret = get_rss_ant3_Atheros_v2(csi_st)
%     error(nargchk(1,1,nargin));
    ret = csi_st.rssi3 - 95;
    ret = double(ret);
end