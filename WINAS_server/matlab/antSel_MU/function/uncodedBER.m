function [uncodBER,fsr] = uncodedBER(BERs)

    uncodBER = zeros(8,1);
    fsr = zeros(8,1);
    bValue_vec = [1, 1, 3, 1, 3, 2, 3, 5]; 
    L = 1500*8;

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
        
        uncodBER(mcs_idx) = pe;
        fsr(mcs_idx) = (1-pe)^L;
       
    end

end

