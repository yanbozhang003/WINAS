function ret = eSNR_series_maintain(arg)
    
    global state;
    global effSNR_series;

    fitWinLen = 1; % window length is 1s
    ema_w = 0.3;

    if state == 0
        % probing state

        effSNR_series.series = arg.eSNR;
        effSNR_series.series_s = arg.eSNR;
        effSNR_series.cbnIdx = arg.bestCbnIdx;
        effSNR_series.tstamp = arg.tstamp;
        if(isnan(arg.eSNR(5:8)))
            warning('first sample is Nan from mcs 5-8!');
        end

        ret = arg;
    end

    if state == 1
        % monitoring state
%         if mean(effSNR_series.cbnIdx) == arg.cbnIdx
        
            [n_sample,~] = size(effSNR_series.series);

            effSNR_series.cbnIdx = arg.cbnIdx;
            effSNR_series.tstamp(n_sample+1,1) = arg.tstamp;
            for i = 1:1:8
                if isnan(arg.eSNR(i))
                    effSNR_series.series(n_sample+1,i) = effSNR_series.series(n_sample,i);
                    effSNR_series.series_s(n_sample+1,i) = (1-ema_w)*effSNR_series.series_s(n_sample,i) + ...
                                                            ema_w*effSNR_series.series(n_sample,i);
                else
                    effSNR_series.series(n_sample+1,i) = arg.eSNR(i);
                    effSNR_series.series_s(n_sample+1,i) = (1-ema_w)*effSNR_series.series_s(n_sample,i) + ema_w*arg.eSNR(i);
                end
            end
            
            if arg.tstamp - effSNR_series.tstamp(1,1) <= fitWinLen
                ret = arg;
            else
                series = effSNR_series.series_s;
%                 % preprocessing the series
%                 series(series==Inf)=NaN;
% %                 for mcsIdx = 1:1:8
%                 for mcsIdx = 5:1:8
%                     series_tmp = series(:,mcsIdx);
%                     sLen = length(series_tmp);
%                     % fill the missing value
%                     n = length(find(isnan(series_tmp)));
%                     if n~=0
%                        if n<sLen
%                             while(~isempty(find(isnan(series_tmp), 1)))
%                                 series_tmp2 = fillmissing(series_tmp,'movmedian',sLen);
%                                 series_tmp = series_tmp2;
%                             end
%                        else
%                            % if all values are NaN for this MCS
%                            fprintf('all NaN mcsIdx: %d\n', mcsIdx);
%                            a = find(~isnan(series(:,mcsIdx+1)));
%                            disp(a);
%                            series_tmp(a(1)) = series(a(1),mcsIdx+1);
%                         
%                            while(~isempty(find(isnan(series_tmp), 1)))
%                                 series_tmp2 = fillmissing(series_tmp,'movmedian',sLen);
%                                 series_tmp = series_tmp2;
%                            end
%                        end
%                     end
%                     
%                     % smooth the series
%                     alpha = 0.3;
%                     series_s = zeros(sLen,1);
%                     for idx = 1:1:sLen
%                         if idx == 1
%                             series_s(idx,1) = series_tmp(idx,1);
%                         end
% 
%                         if idx > 1
%                             series_s(idx,1) = alpha*series_tmp(idx,1)+(1-alpha)*series_s(idx-1,1);
%                         end
%                     end
%                     
%                     % replace the original value
%                     series(:,mcsIdx) = series_s;
%                 end
                
                winTail = n_sample+1;
                [~,winHead_v] = find(effSNR_series.tstamp<(arg.tstamp - fitWinLen));
                winHead = winHead_v(length(winHead_v));
                
                ret.eSNR = series(winHead:winTail,:);
                ret.tstamp = effSNR_series.tstamp(winHead:winTail,1);
                ret.uBER = arg.uBER;
                ret.cbnIdx = arg.cbnIdx;
            end
%         else
%             error('cbnIdx changed during monitoring!\n');
%         end
    end
end

