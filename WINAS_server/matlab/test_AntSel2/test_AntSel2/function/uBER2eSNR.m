function ret = uBER2eSNR(u_ber)

    % esnr can be Inf when u_ber is near 0
    % and can be nan when u_ber is larger than 3/4 for 16qam or 7/12 for
    % 64qam
    
    % for the two bugs,
    % set esnr to 40dB if Inf, and set it to eps if NaN

    ret = zeros(8,1);
    for mcsIdx = 1:1:8
        ber = u_ber(mcsIdx);
        switch mcsIdx
            case 1
                ret(mcsIdx) = qfuncinv(ber).^2 / 2;
            case 2
                ret(mcsIdx) = qfuncinv(ber).^2;
            case 3
                ret(mcsIdx) = qfuncinv(ber).^2;
            case 4
                ret(mcsIdx) = qfuncinv(ber * 4/3).^2 * 5;
            case 5
                ret(mcsIdx) = qfuncinv(ber * 4/3).^2 * 5;
            case 6
                ret(mcsIdx) = qfuncinv(12/7*ber).^2*21;
            case 7
                ret(mcsIdx) = qfuncinv(12/7*ber).^2*21;
            case 8
                ret(mcsIdx) = qfuncinv(12/7*ber).^2*21;
            otherwise
                error('uBER2eSNR mcs error!');
        end
    end
    ret(ret==Inf) = dbinv(40);
%     ret(isnan(ret)) = eps;
%     disp(pow2db(ret))
end

