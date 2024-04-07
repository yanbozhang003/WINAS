function ret = antCbn_mapping(arg)

    % make sure all antennas are probed
    prb_cbn = [1,22,43,64];
    ant_cbn = arg.cbnIdx;
    f1 = isempty(find(ant_cbn==prb_cbn(1), 1));
    f2 = isempty(find(ant_cbn==prb_cbn(2), 1));
    f3 = isempty(find(ant_cbn==prb_cbn(3), 1));
    f4 = isempty(find(ant_cbn==prb_cbn(4), 1));
    

    if (f1==0 && f2==0 && f3==0 && f4==0)
        ret.CSI = zeros(64,3,3,56);
        ret.RSSI = zeros(64,3);

        for ch1_rf_idx = 1:1:4
            for ch2_rf_idx = 1:1:4
                for ch3_rf_idx = 1:1:4
                    cbn_idx = (ch1_rf_idx-1)*16+(ch2_rf_idx-1)*4+(ch3_rf_idx-1)+1;

                    csi_tmp = cat(2,arg.CSI(ch1_rf_idx,1,:,:),...
                                    arg.CSI(ch2_rf_idx,2,:,:),...
                                    arg.CSI(ch3_rf_idx,3,:,:));
                    rssi_tmp = cat(2,arg.RSSI(ch1_rf_idx,1),...
                                     arg.RSSI(ch2_rf_idx,2),...
                                     arg.RSSI(ch3_rf_idx,3));

                    ret.CSI(cbn_idx,:,:,:) = csi_tmp;
                    ret.RSSI(cbn_idx,:) = rssi_tmp;
                end
            end
        end

        ret.tstamp = arg.tstamp(4);
    else
        error('Not all antennas are probed, quit antSel!');
    end
end

