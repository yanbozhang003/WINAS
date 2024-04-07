% find the most frequent rssi value_v2_ant2

function ret = find_rssi2_freq_v2(rssi_ant2)
    rssi_freq_table = tabulate(rssi_ant2);
    [m,idx] = max(rssi_freq_table(:,2));
    ret = rssi_freq_table(idx);
end