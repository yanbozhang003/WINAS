clear;
close all

load('testcsi.mat');

for i = 1:1:4
    cnt = 0;
    csi = squeeze(csiBuffer.CSI(i,:,:,:));
    
    for tx = 1:1:3
        for rx = 1:1:3
            csi_plt = db(abs(squeeze(csi(rx,tx,:))));
            
            cnt = cnt+1;
            subplot(3,3,cnt)
            plot(csi_plt);hold on
        end
    end
    
    waitforbuttonpress;
end