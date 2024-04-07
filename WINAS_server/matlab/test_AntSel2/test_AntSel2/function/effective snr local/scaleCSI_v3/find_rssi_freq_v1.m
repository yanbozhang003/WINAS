% find the most frequent rssi value_v1

function ret = find_rssi_freq_v1(rssi_total)
    rssi_freq_table = tabulate(rssi_total);
    [m,idx] = max(rssi_freq_table(:,2));
    ret = rssi_freq_table(idx);
end