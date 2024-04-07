clear;
close all

%% fsr = (1-ber)^L;
%%%%%%%%%%%%%%%%%%%%%%%%

L = 1500*8; % say packet length is 1500 bytes

fsr_v = zeros(1,1);
ber_v = zeros(1,1);
cnt = 0;
for ber = 0:10e-6:0.001
    
    cnt = cnt+1;
    ber_v(cnt) = ber;
    fsr_v(cnt) = (1-ber)^L;
    
end

plot(ber_v, fsr_v, 'k.-');