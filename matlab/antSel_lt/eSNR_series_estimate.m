function ret = eSNR_series_estimate(arg)
    
    global model;
    
    scaling_f = 1000;
    
    esnr_series = arg.eSNR;
    esnr_series = esnr_series/scaling_f; % scale to ~(0-1)
    
%     for mcsIdx = 1:1:8
    for mcsIdx = 5:1:8
        x = esnr_series(:,mcsIdx);
        x = x';
        
%         fprintf('mcsIdx: %d\n',mcsIdx);
%         disp(x);
        y = predict(model, x);
        
        if ~isempty(find(y<=0, 1))
            y(y<=0)=NaN;
            while(~isempty(find(isnan(y), 1)))
                y2 = fillmissing(y,'movmedian',10);
                y = y2;
            end
        end
        
        ret.eSNR(:,mcsIdx) = y*scaling_f;
    end

    ret.uBER = arg.uBER;
    ret.cbnIdx = arg.cbnIdx;
    ret.tstamp = arg.tstamp(length(arg.tstamp));

end

