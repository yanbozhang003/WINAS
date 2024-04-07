function corr_v = calculateCorr(csiRef, csiTst)
    % csiR(T): 3x3x56
    % corr_v: 1x3
    corr_v = zeros(1,3);
    
    csiR_r1 = squeeze(csiRef(1,:,:));
    csiR_r2 = squeeze(csiRef(2,:,:));
    csiR_r3 = squeeze(csiRef(3,:,:));
    csiT_r1 = squeeze(csiTst(1,:,:));
    csiT_r2 = squeeze(csiTst(2,:,:));
    csiT_r3 = squeeze(csiTst(3,:,:));
    
    % for chain1 
    csiR_t1 = unwrap(angle(squeeze(csiR_r1(1,:))));
    csiR_t2 = unwrap(angle(squeeze(csiR_r1(2,:))));
    csiR_t3 = unwrap(angle(squeeze(csiR_r1(3,:))));    
    csiR_t1 = exp(1i*csiR_t1);
    csiR_t2 = exp(1i*csiR_t2);
    csiR_t3 = exp(1i*csiR_t3);
    csiR_t12 = csiR_t1 ./ csiR_t2;
    csiR_t13 = csiR_t1 ./ csiR_t3;
    csiR_t23 = csiR_t2 ./ csiR_t3;
    
    csiT_t1 = unwrap(angle(squeeze(csiT_r1(1,:))));
    csiT_t2 = unwrap(angle(squeeze(csiT_r1(2,:))));
    csiT_t3 = unwrap(angle(squeeze(csiT_r1(3,:))));
    csiT_t1 = exp(1i*csiT_t1);
    csiT_t2 = exp(1i*csiT_t2);
    csiT_t3 = exp(1i*csiT_t3);
    csiT_t12 = csiT_t1 ./ csiT_t2;
    csiT_t13 = csiT_t1 ./ csiT_t3;
    csiT_t23 = csiT_t2 ./ csiT_t3;
    
    corr12 = computCorr(csiR_t12, csiT_t12);
    corr13 = computCorr(csiR_t13, csiT_t13);
    corr23 = computCorr(csiR_t23, csiT_t23);

    corr_v(1,1) = (corr12+corr13+corr23)/3;
    
    % for chain2
    csiR_t1 = unwrap(angle(squeeze(csiR_r2(1,:))));
    csiR_t2 = unwrap(angle(squeeze(csiR_r2(2,:))));
    csiR_t3 = unwrap(angle(squeeze(csiR_r2(3,:))));    
    csiR_t1 = exp(1i*csiR_t1);
    csiR_t2 = exp(1i*csiR_t2);
    csiR_t3 = exp(1i*csiR_t3);
    csiR_t12 = csiR_t1 ./ csiR_t2;
    csiR_t13 = csiR_t1 ./ csiR_t3;
    csiR_t23 = csiR_t2 ./ csiR_t3;
    
    csiT_t1 = unwrap(angle(squeeze(csiT_r2(1,:))));
    csiT_t2 = unwrap(angle(squeeze(csiT_r2(2,:))));
    csiT_t3 = unwrap(angle(squeeze(csiT_r2(3,:))));
    csiT_t1 = exp(1i*csiT_t1);
    csiT_t2 = exp(1i*csiT_t2);
    csiT_t3 = exp(1i*csiT_t3);
    csiT_t12 = csiT_t1 ./ csiT_t2;
    csiT_t13 = csiT_t1 ./ csiT_t3;
    csiT_t23 = csiT_t2 ./ csiT_t3;
    
    corr12 = computCorr(csiR_t12, csiT_t12);
    corr13 = computCorr(csiR_t13, csiT_t13);
    corr23 = computCorr(csiR_t23, csiT_t23);

    corr_v(1,2) = (corr12+corr13+corr23)/3;
    
    % for chain3
    csiR_t1 = unwrap(angle(squeeze(csiR_r3(1,:))));
    csiR_t2 = unwrap(angle(squeeze(csiR_r3(2,:))));
    csiR_t3 = unwrap(angle(squeeze(csiR_r3(3,:))));    
    csiR_t1 = exp(1i*csiR_t1);
    csiR_t2 = exp(1i*csiR_t2);
    csiR_t3 = exp(1i*csiR_t3);
    csiR_t12 = csiR_t1 ./ csiR_t2;
    csiR_t13 = csiR_t1 ./ csiR_t3;
    csiR_t23 = csiR_t2 ./ csiR_t3;
    
    csiT_t1 = unwrap(angle(squeeze(csiT_r3(1,:))));
    csiT_t2 = unwrap(angle(squeeze(csiT_r3(2,:))));
    csiT_t3 = unwrap(angle(squeeze(csiT_r3(3,:))));
    csiT_t1 = exp(1i*csiT_t1);
    csiT_t2 = exp(1i*csiT_t2);
    csiT_t3 = exp(1i*csiT_t3);
    csiT_t12 = csiT_t1 ./ csiT_t2;
    csiT_t13 = csiT_t1 ./ csiT_t3;
    csiT_t23 = csiT_t2 ./ csiT_t3;
    
    corr12 = computCorr(csiR_t12, csiT_t12);
    corr13 = computCorr(csiR_t13, csiT_t13);
    corr23 = computCorr(csiR_t23, csiT_t23);

    corr_v(1,3) = (corr12+corr13+corr23)/3;
end

