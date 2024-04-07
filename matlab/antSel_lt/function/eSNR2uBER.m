function ret = eSNR2uBER(esnr)
    
    ret = zeros(8,10);
    for mcsIdx = 1:1:8
        esnr_v = esnr(:,mcsIdx);
        switch mcsIdx
%             case 1
%                 s1 = sqrt(2*esnr_v);
%                 ret(mcsIdx,:) = qfunc(s1);
%             case 2
%                 ret(mcsIdx,:) = qfunc(sqrt(esnr_v));
%             case 3
%                 ret(mcsIdx,:) = qfunc(sqrt(esnr_v));
%             case 4
%                 ret(mcsIdx,:) = 3/4*qfunc(sqrt(esnr_v/5));
            case 5
                ret(mcsIdx,:) = 3/4*qfunc(sqrt(esnr_v/5));
            case 6
                ret(mcsIdx,:) = 7/12*qfunc(sqrt(esnr_v/21));
            case 7
                ret(mcsIdx,:) = 7/12*qfunc(sqrt(esnr_v/21));
            case 8
                ret(mcsIdx,:) = 7/12*qfunc(sqrt(esnr_v/21));
            otherwise
                ret(mcsIdx,:) = 0;
%                 error('uBER2eSNR mcs error!');
        end
    end

end

