function ret = get_rss_ant2_Atheros_v2(csi_st)
%     error(nargchk(1,1,nargin));
    ret = csi_st.rssi2 - 95;
    ret = double(ret);
end