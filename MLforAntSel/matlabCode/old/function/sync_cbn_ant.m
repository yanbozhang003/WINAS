function cbn = sync_cbn_ant(Ch1_idx, Ch2_idx)

    % only for the use of "AntSel_eSNR4cbn_prt1.m"
    
    if(Ch1_idx==1 && Ch2_idx==5)
        cbn = 10;
    elseif(Ch1_idx==1 && Ch2_idx==6)
        cbn = 2;
    elseif(Ch1_idx==1 && Ch2_idx==7)
        cbn = 8;
    elseif(Ch1_idx==1 && Ch2_idx==8)
        cbn = 16;
    elseif(Ch1_idx==2 && Ch2_idx==5)
        cbn = 14;
    elseif(Ch1_idx==2 && Ch2_idx == 6)
        cbn = 6;
    elseif(Ch1_idx==2 && Ch2_idx == 7)
        cbn = 12;
    elseif(Ch1_idx==2 && Ch2_idx == 8)
        cbn = 4;
    elseif(Ch1_idx==3 && Ch2_idx==5)
        cbn = 11;
    elseif(Ch1_idx==3 && Ch2_idx==6)
        cbn = 3;
    elseif(Ch1_idx==3 && Ch2_idx==7)
        cbn = 9;
    elseif(Ch1_idx==3 && Ch2_idx==8)
        cbn = 1;
    elseif(Ch1_idx==4 && Ch2_idx==5)
        cbn = 15;
    elseif(Ch1_idx==4 && Ch2_idx == 6)
        cbn = 7;
    elseif(Ch1_idx==4 && Ch2_idx == 7)
        cbn = 13;
    elseif(Ch1_idx==4 && Ch2_idx == 8)
        cbn = 5;
    else
        cbn = 0;
    end

end

