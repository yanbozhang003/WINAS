%
% (c) 2008-2011 Daniel Halperin <dhalperi@cs.washington.edu>
%
function ret = bpsk_ber(snr)
    s1 = sqrt(2*snr);
    ret = qfunc(s1);
end
