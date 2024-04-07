function ret = systemStateCtrl(arg)
    
    global state;
    global TP_series_top;
    global TP_series_inUse;
    global hist_TP_series_top;
    global hist_TP_series_inUse;
    global effSNR_series;
    global cnt;
    
    threshold = 100*10^6;
    
    %% set 802.11 parameters
    L = 1500*8;     % packet length use 1500 bytes
    slot_time = 9*10^-6;
    SIFS = 16*10^-6;
    DIFS = 2*slot_time + SIFS;
    BO = 7.5*(slot_time);
    ACK_delay = (8+8+4+(14*8/6))*10^-6;
    
    Rate_v = [19.5, 39, 58.5, 78, ...
                117, 156, 175.5, 195]*10^6;

    O = DIFS+BO+SIFS+ACK_delay;
    T = L./Rate_v;
    Duration = O+T;

    %%
    
    cnt = cnt+1;
    if state == 0
        % probing state
        % refresh the TP series
        TP_series_top.series = zeros(1,1);
        TP_series_inUse.series = zeros(1,1);
        TP_series_top.tstamp = zeros(1,1);
        TP_series_inUse.tstamp = zeros(1,1);
        TP_series_top.cbnIdx = zeros(1,1);
        TP_series_inUse.cbnIdx = zeros(1,1);
        
        TP = max(L*((1-arg.uBER).^L)./Duration);
        
        TP_series_top.series(1,1) = TP;
        TP_series_inUse.series(1,1) = TP;
        hist_TP_series_top.series(cnt,1) = TP;
        hist_TP_series_inUse.series(cnt,1) = TP;
        
        TP_series_top.tstamp(1,1) = arg.tstamp;
        TP_series_inUse.tstamp(1,1) = arg.tstamp;
        hist_TP_series_top.tstamp(cnt,1) = arg.tstamp;
        hist_TP_series_inUse.tstamp(cnt,1) = arg.tstamp;
        
        TP_series_top.cbnIdx(1,1) = arg.bestCbnIdx;
        TP_series_inUse.cbnIdx(1,1) = arg.bestCbnIdx;
        hist_TP_series_top.cbnIdx(cnt,1) = arg.bestCbnIdx;
        hist_TP_series_inUse.cbnIdx(cnt,1) = arg.bestCbnIdx;
        
        state = 1;
        ret = arg.bestCbnIdx;
    else
        % monitoring state
        [series_len,~] = size(arg.eSNR);
        [count,~] = size(effSNR_series.series);
        
        if series_len == 1 
            % during data collection
            TP = max(L*((1-arg.uBER).^L)./Duration);
            
            TP_series_top.series(count,1) = TP;
            TP_series_inUse.series(count,1) = TP;
            hist_TP_series_top.series(cnt,1) = TP;
            hist_TP_series_inUse.series(cnt,1) = TP;
            
            TP_series_top.tstamp(count,1) = arg.tstamp;
            TP_series_inUse.tstamp(count,1) = arg.tstamp;
            hist_TP_series_top.tstamp(cnt,1) = arg.tstamp;
            hist_TP_series_inUse.tstamp(cnt,1) = arg.tstamp;
            
            TP_series_top.cbnIdx(count,1) = arg.cbnIdx;
            TP_series_inUse.cbnIdx(count,1) = arg.cbnIdx;
            hist_TP_series_top.cbnIdx(cnt,1) = arg.cbnIdx;
            hist_TP_series_inUse.cbnIdx(cnt,1) = arg.cbnIdx;
            
            ret = arg.cbnIdx;
        else
            % decide if trigger probing
            TP = max(L*((1-arg.uBER).^L)./Duration);    
            
            % due to real time sampling issue (large sampling interval),
            % don't use average
            TP_top = TP_series_top.series(1,1);
            
            TP_series_top.series(count,1) = TP_top;
            TP_series_inUse.series(count,1) = TP;
            hist_TP_series_top.series(cnt,1) = TP_top;
            hist_TP_series_inUse.series(cnt,1) = TP;
            
            TP_series_top.tstamp(count,1) = arg.tstamp;
            TP_series_inUse.tstamp(count,1) = arg.tstamp;
            hist_TP_series_top.tstamp(cnt,1) = arg.tstamp;
            hist_TP_series_inUse.tstamp(cnt,1) = arg.tstamp;
            
            TP_series_top.cbnIdx(count,1) = arg.cbnIdx;
            TP_series_inUse.cbnIdx(count,1) = arg.cbnIdx;
            hist_TP_series_top.cbnIdx(cnt,1) = arg.cbnIdx;
            hist_TP_series_inUse.cbnIdx(cnt,1) = arg.cbnIdx;
            
            pred_esnr_series = arg.eSNR;
            uber_series = eSNR2uBER(pred_esnr_series); % size 8x10
            
            Duration_mat = repmat(Duration',1,10); % size 8x10
            TP_tmp1 = L*((1-uber_series).^L)./Duration_mat;
            TP_tmp2 = max(TP_tmp1,[],1);
            TP_mean = mean(TP_tmp2);
            
            delta = TP_top - TP_mean;
            
            if delta > threshold || TP_top <= 55*10^6
%             if delta > threshold
                state = 0;
                ret = 1;
            else
                state = 1;
                ret = arg.cbnIdx;
            end
        end
        
    end

end

