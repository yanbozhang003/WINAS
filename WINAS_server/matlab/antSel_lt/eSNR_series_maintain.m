function ret = eSNR_series_maintain(arg)
    
    global state;
    global effSNR_series;

    fitWinLen = 20;

    if state == 0
        % probing state

        effSNR_series.series = arg.eSNR;
        effSNR_series.cbnIdx = arg.bestCbnIdx;
        effSNR_series.tstamp = arg.tstamp;

        ret = arg;
    end

    if state == 1
        % monitoring state
        if mean(effSNR_series.cbnIdx) == arg.cbnIdx
        
            [n_sample,~] = size(effSNR_series.series);

            effSNR_series.series(n_sample+1,:) = arg.eSNR;
            effSNR_series.cbnIdx = arg.cbnIdx;
            effSNR_series.tstamp(n_sample+1,1) = arg.tstamp;       

            if n_sample < fitWinLen
                ret = arg;
            else
                series = effSNR_series.series;
                % preprocessing the series
                series(series==Inf)=NaN;
%                 for mcsIdx = 1:1:8
                for mcsIdx = 5:1:8
                    series_tmp = series(:,mcsIdx);
                    sLen = length(series_tmp);
                    % fill the missing value
                    n = length(find(isnan(series_tmp)));
                    if n~=0
                       if n<sLen
                            while(~isempty(find(isnan(series_tmp), 1)))
                                series_tmp2 = fillmissing(series_tmp,'movmedian',sLen);
                                series_tmp = series_tmp2;
                            end
                       else
                           % if all values are NaN for this MCS
                           fprintf('all NaN mcsIdx: %d\n', mcsIdx);
                           a = find(~isnan(series(:,mcsIdx+1)));
                           disp(a);
                           series_tmp(a(1)) = series(a(1),mcsIdx+1);
                        
                           while(~isempty(find(isnan(series_tmp), 1)))
                                series_tmp2 = fillmissing(series_tmp,'movmedian',sLen);
                                series_tmp = series_tmp2;
                           end
                       end
                    end
                    
                    % smooth the series
                    alpha = 0.3;
                    series_s = zeros(sLen,1);
                    for idx = 1:1:sLen
                        if idx == 1
                            series_s(idx,1) = series_tmp(idx,1);
                        end

                        if idx > 1
                            series_s(idx,1) = alpha*series_tmp(idx,1)+(1-alpha)*series_s(idx-1,1);
                        end
                    end
                    
                    % replace the original value
                    series(:,mcsIdx) = series_s;
                end
                
                winTail = n_sample;
                winHead = winTail - fitWinLen +1;

                ret.eSNR = series(winHead:winTail,:);
                ret.tstamp = effSNR_series.tstamp(winHead:winTail,1);
                ret.uBER = arg.uBER;
                ret.cbnIdx = arg.cbnIdx;
            end
        else
            error('cbnIdx changed during monitoring!\n');
        end
    end
end

