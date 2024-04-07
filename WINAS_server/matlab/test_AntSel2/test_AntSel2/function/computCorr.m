function corr = computCorr(v1,v2)
% input: v1,v2: complex vector

%     v2_conj = conj(v2)';
    v1_v2   = v1 * v2';
    v1_amp = norm(v1);
    v2_amp = norm(v2);
    corr = abs(v1_v2 / (v1_amp * v2_amp));

end

