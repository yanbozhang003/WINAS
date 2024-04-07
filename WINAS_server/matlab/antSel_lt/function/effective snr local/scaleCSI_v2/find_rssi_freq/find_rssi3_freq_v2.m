% find the most frequent rssi value_v2_ant3

function ret = find_rssi3_freq_v2(rssi_ant3)
    rssi_freq_table = tabulate(rssi_ant3);
    [m,idx] = max(rssi_freq_table(:,2));
    ret = rssi_freq_table(idx);
end