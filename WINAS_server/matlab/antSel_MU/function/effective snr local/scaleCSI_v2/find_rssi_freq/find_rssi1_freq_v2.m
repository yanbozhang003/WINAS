% find the most frequent rssi value_v2_ant1

function ret = find_rssi1_freq_v2(rssi_ant1)
    rssi_freq_table = tabulate(rssi_ant1);
    [m,idx] = max(rssi_freq_table(:,2));
    ret = rssi_freq_table(idx);
end