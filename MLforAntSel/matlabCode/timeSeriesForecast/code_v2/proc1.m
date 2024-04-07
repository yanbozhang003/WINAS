clear;
close all

addpath('./function/');
addpath('../function/effective snr local/');
addpath('../function/effective snr local/scaleCSI_v2');

load('./tmp/moving_measure1.mat');

n_pkt = length(csi_struct);

csi_prb4 = zeros(4,1,3,3,56);
csi_prb4_rmSM = zeros(4,1,3,3,56);
rssi_prb4 = zeros(4,1,3);
csi_cbn_time = zeros(64,3,3,56);
rssi_cbn_time = zeros(64,3);
esnr_cbn = zeros(64,1);
esnr_maxIdx_tr = zeros(100,1);
esnr_tr = zeros(100,1);
tr_cnt = 0;
prb_cnt = 0;
filtered_cnt=0;
for pkt_idx = 1:1:n_pkt   
    cbn_idx = csi_struct{pkt_idx,1}.ant_cbn;
    prb_cnt = mod(cbn_idx,4);
    if prb_cnt==0
        prb_cnt=4;
    end
    
    csi_ori = csi_struct{pkt_idx,1}.csi;
    csi_length = csi_struct{pkt_idx,1}.csi_len;
    n_rx = csi_struct{pkt_idx,1}.nr;
    n_tx = csi_struct{pkt_idx,1}.nc;
    payL = csi_struct{pkt_idx,1}.payload_len;
    rssi_1 = csi_struct{pkt_idx,1}.rssi1;
    rssi_2 = csi_struct{pkt_idx,1}.rssi2;
    rssi_3 = csi_struct{pkt_idx,1}.rssi3;
    
    if(csi_length==0)
       filtered_cnt = filtered_cnt+1;
       warning('one packet filtered out. ant-cbn mapping may be incorrect!');
       continue
   end
   if(or(n_rx~=3,n_tx~=3))
       filtered_cnt = filtered_cnt+1;
       warning('one packet filtered out. ant-cbn mapping may be incorrect!');
       continue
   end
%    if(pay_len~=565)
%        continue
%    end
   if(rssi_1==255 || rssi_2==255 || rssi_3==255) 
       warning('one packet filtered out. ant-cbn mapping may be incorrect!');
       filtered_cnt = filtered_cnt+1;
       continue
   end
   
   csi_prb4(prb_cnt,1,:,:,:) = csi_ori;
   csi_prb4_rmSM(prb_cnt,1,:,:,:) = rm_sm(csi_ori);
   rssi_prb4(prb_cnt,1,1) = rssi_1;
   rssi_prb4(prb_cnt,1,2) = rssi_2;
   rssi_prb4(prb_cnt,1,3) = rssi_3;
   
   if(prb_cnt==4)
       tr_cnt =  tr_cnt+1;
       
       for ch1_rf_idx = 1:1:4
           for ch2_rf_idx = 1:1:4
               for ch3_rf_idx = 1:1:4
                   cbn_idx = (ch1_rf_idx-1)*16+(ch2_rf_idx-1)*4+(ch3_rf_idx-1)+1;

                   csi_tmp = cat(3,csi_prb4(ch1_rf_idx,:,1,:,:),...
                                   csi_prb4(ch2_rf_idx,:,2,:,:),...
                                   csi_prb4(ch3_rf_idx,:,3,:,:));
                   rssi_tmp = cat(3,rssi_prb4(ch1_rf_idx,:,1),...
                                    rssi_prb4(ch2_rf_idx,:,2),...
                                    rssi_prb4(ch3_rf_idx,:,3));
                   
                   csi = squeeze(csi_tmp(1,1,:,:,:));
                   rssi = squeeze(rssi_tmp(1,1,:));

                   csi_new = permute(csi,[2 1 3]);
                   csi_scaled = get_scaled_csi_Atheros_v2(csi_new,rssi);
                   effSNR = get_eff_SNRs(csi_scaled);

                   esnr_cbn(cbn_idx,1) = effSNR(7,4);
                   csi_cbn_time(cbn_idx, :,:,:) = csi;
                   rssi_cbn_time(cbn_idx, :) = rssi;
               end
           end
       end
       save(['./data/mat/measure1/time_tr',num2str(tr_cnt),'.mat'],...
            'esnr_cbn','csi_cbn_time','rssi_cbn_time','csi_prb4_rmSM');
%        [esnr_tr(tr_cnt),esnr_maxIdx_tr(tr_cnt)]=max(esnr_cbn(:,tr_cnt));
%        prb_cnt=0;
   end
   disp(pkt_idx)
end