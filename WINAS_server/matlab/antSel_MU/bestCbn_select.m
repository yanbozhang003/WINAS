function ret = bestCbn_select(arg)

    global esnr_bestCbn;

    [n_cbn,~] = size(arg.uBER);
    %% set 802.11 parameters
    L = 1500*8;     % packet length use 1500 bytes
    slot_time = 9*10^-6;
    SIFS = 16*10^-6;
    DIFS = 2*slot_time + SIFS;
    BO = 7.5*(slot_time);
    ACK_delay = (8+8+4+(14*8/(6*10^6)))*10^-6;
    
    Rate_v = [19.5, 39, 58.5, 78, ...
                117, 156, 175.5, 195]*10^6;

    O = DIFS+BO+SIFS+ACK_delay;
    T = L ./ Rate_v;
    Duration = O+T;
    
    %% compute throughput
    uBER_mat = arg.uBER;
    FSR_mat = (1-uBER_mat).^L;
    
    Duration_mat = repmat(Duration,n_cbn,1);

    TP_mat = (L*FSR_mat)./(Duration_mat);
    TP_v = max(TP_mat,[],2); % select max TP for each cbn
    [~,cbnIdx] = max(TP_v); % select best Cbn Idx

    esnr_ori = arg.esnr_ori;
    [esnr_bestCbn,cbnIdx] = max(esnr_ori);
    
    ret.tstamp = arg.tstamp;
    ret.eSNR = arg.eSNR(cbnIdx,:);
    ret.uBER = arg.uBER(cbnIdx,:);
    ret.bestCbnIdx = cbnIdx;
end

