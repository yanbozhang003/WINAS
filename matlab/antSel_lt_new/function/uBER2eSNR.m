function ret = uBER2eSNR(u_ber)
    
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

end

