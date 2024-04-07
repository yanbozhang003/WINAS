function ret = eSNR_series_estimate(arg)
    
    global model;
    
    esnr_series = arg.eSNR;
    tstamp = arg.tstamp;
    tstamp_ref = tstamp(length(tstamp));
    tstamp_x = zeros(1,20);
    tstamp_y = zeros(1,10);
    for i = 1:1:20
        tstamp_x(i) = tstamp_ref - 0.05*(20-i);
    end
    for i = 1:1:10
        tstamp_y(i) = tstamp_ref + 0.01*i;
    end
    
%     for mcsIdx = 1:1:8
    for mcsIdx = 5:1:8
        x_r = zeros(20,1);
        x = esnr_series(:,mcsIdx);
        % resample
        for j = 1:1:20
            t = tstamp_x(j);
            left_v = find(tstamp<t);
            left_idx = left_v(length(left_v));
            right_idx = left_idx+1;
            x_left = x(left_idx,1);
            x_right = x(right_idx,1);
            x_r(j) = (x_left+x_right)/2;
        end
        % interpolation
        t_head = tstamp_x(1);
        t_end = tstamp_x(length(tstamp_x));
        tstamp_x_interp = t_head:0.01:t_end;
        x_rp = interp1(tstamp_x, x_r, tstamp_x_interp);
        
%         if mcsIdx==5
% %       % visualize the resampled data
%         plot(tstamp,esnr_series(:,mcsIdx),'k.-','MarkerSize',20);hold on;
%         plot(tstamp_x,x_r,'o',tstamp_x_interp, x_rp, '.-');hold on
%         end
        
        scaling_f = max(x_rp);
        x_rp = x_rp/scaling_f;   % scale
        

%         x_rp = x_rp';
%         fprintf('mcsIdx: %d\n',mcsIdx);
%         disp(x);
        y = predict(model, x_rp);
        y = y*scaling_f;
        
%         if mcsIdx == 5
% %          % visualize the predicted result
%         plot(tstamp_y,y,'b.-','MarkerSize',20);hold off
%         end

        % because of the model isn't perfect, y can contain negative values
        if ~isempty(find(y<=0, 1))
            y(y<=0)=NaN;
            while(~isempty(find(isnan(y), 1)))
                y2 = fillmissing(y,'movmedian',10);
                y = y2;
            end
        end
        
        ret.eSNR(:,mcsIdx) = y;
    end

    ret.uBER = arg.uBER;
    ret.cbnIdx = arg.cbnIdx;
    ret.tstamp = arg.tstamp(length(arg.tstamp));

end

