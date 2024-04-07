function THs = get_thrpt(BERs)

%     BERs: (bpsk_ber, qpsk_ber, 16qam_ber, 64qam_ber)
%     THs: for each MCS, we compute a throughput

    THs = zeros(8,1);

    % set fixed parameters
    L = 4500*8;     % packet length is 1500 bytes
    Rate_vec = [19.5, 39, 58.5, 78, 117, 156, 175.5, 195]*10^6; % DataRate for MCS16-23, with unit bps
    DIFS = 34*10^-6; % (s)
    SIFS = 16*10^-6;
    BO = 7.5*(9*10^-6);
    ACK_delay = (8+8+4+(14*8/(6*10^6)))*10^-6;
    
    O = DIFS+SIFS+BO+ACK_delay;

    % set bValue for each MCS
    bValue_vec = [1, 1, 3, 1, 3, 2, 3, 5]; 

    for mcs_idx = 1:1:8
       
        bValue = bValue_vec(mcs_idx);
        
        if mcs_idx == 1     % bpsk
            ber = BERs(1);
        end
        if (mcs_idx == 2) || (mcs_idx == 3)    % qpsk
            ber = BERs(2);
        end
        if (mcs_idx == 4) || (mcs_idx == 5)    % 16qam
            ber = BERs(3);
        end
        if (mcs_idx == 6) || (mcs_idx == 7) || (mcs_idx == 8)    % 64qam
            ber = BERs(4);
        end
        
        pe = CalculatePe(ber, bValue);
        pe = min(pe,1);
        R  = Rate_vec(mcs_idx);
        
%         disp(L);
%         disp((1-pe)^L);
%         disp(O+L/R);
%         
%         throughput = (L*(1-pe)^L)/(O+L/R);
%         
%         disp(throughput/1000000);
        
        THs(mcs_idx,1) = (L*(1-pe)^L)/(O+L/R);
    end
    

end

