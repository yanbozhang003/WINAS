function ret = get_rss_ant1_Atheros_v2(csi_st)
%     error(nargchk(1,1,nargin));
    ret = csi_st.rssi1 - 95;
    ret = double(ret);
end