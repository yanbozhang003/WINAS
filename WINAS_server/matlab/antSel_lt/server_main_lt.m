% Only 3x3 implemented

clear;
close all
addpath('./function');
addpath('./function/msocket_func/');
addpath('./function/effective snr local/');
addpath('./function/effective snr local/scaleCSI_v2');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   SOCKET  Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
server_sock = mslisten(6767);
sock_vec_in = zeros(1,1,'int32');
sock_vec_in(1,1) = server_sock;
sock_cnt_in = length(sock_vec_in); 
sock_max = max(sock_vec_in);
sock_min = min(sock_vec_in);

n_sc = 56; 
n_txSS = 3;
n_rxCH = 3;
n_cbn  = 4^n_rxCH;
rate_v = 144:1:151;
probing_cbn = [1,22,43,64];

global state;
state = 0;      % start from probing state
global cnt;
cnt = 0;
global effSNR_series;
effSNR_series.series = zeros(8,1);
effSNR_series.cbnIdx = zeros(1,1);
effSNR_series.tstamp = zeros(1,1);
global TP_series_top;
TP_series_top.series = zeros(1,1);
TP_series_top.tstamp = zeros(1,1);
TP_series_top.cbnIdx = zeros(1,1);
global TP_series_inUse;
TP_series_inUse.series = zeros(1,1);
TP_series_inUse.tstamp = zeros(1,1);
TP_series_inUse.cbnIdx = zeros(1,1);
global hist_TP_series_top;
hist_TP_series_top.series = zeros(1,1);
hist_TP_series_top.tstamp = zeros(1,1);
hist_TP_series_top.cbnIdx = zeros(1,1);
global hist_TP_series_inUse;
hist_TP_series_inUse.series = zeros(1,1);
hist_TP_series_inUse.tstamp = zeros(1,1);
hist_TP_series_inUse.cbnIdx = zeros(1,1);

% csiBuffer is a structure containing:
%   1) CSI: 4x3x3x56
%   2) RSSI: 4x3
%   3) antenna combination index: 4x1
%   4) timestamp: 4x1
% No need to be global
csiBuffer.CSI = zeros(4, n_rxCH, n_txSS, n_sc);
csiBuffer.RSSI = zeros(4, n_rxCH);
csiBuffer.cbnIdx = zeros(4,1);
csiBuffer.tstamp = zeros(4,1);

% csiStruct is a structure containing:
%   1) CSI: 3x3x56
%   2) RSSI: 1x3
%   3) antenna combination index: 1x1
%   4) timestamp: 1x1
% No need to be global
csiStruct.CSI = zeros(n_rxCH, n_txSS, n_sc);
csiStruct.RSSI = zeros(1, n_rxCH);
csiStruct.cbnIdx = zeros(1,1);
csiStruct.tstamp = zeros(1,1);

% save traces for debugging
dbg_cnt = 0;
state_cnt = 0;
dbg_csi_mat = zeros(1,3,3,56);
dbg_rssi_mat = zeros(1,3);
dbg_rate_mat = zeros(1,1);
dbg_paylen_mat = zeros(1,1);
dbg_timest_mat = zeros(1,1);
dbg_state_vec = zeros(1,1);

dbg_csiBuffer_cnt = 0;
dbg_csiBuffer_v = cell(1,1);

dbg_esnr_tmp = zeros(1,1);
esnr_cnt = 0;
esnr_hist_cnt = 0;
tstamp_cnt = 0;
tstamp_new_AC = zeros(1,1);
esnr_init = zeros(1,1);
esnr_hist = zeros(1,1);
wht = 0.5;
while 1    
    tic
    [sock_vec_out,sock_cnt_out,CSI_struct] = msCSI_server_tmp(sock_cnt_in,sock_vec_in,sock_min,sock_max,2);
    
    if (length(sock_vec_in) > 1)                        % we connect with at least 1 client
        if (length(CSI_struct) >= 1)                     % the output CSI structure must not be empty
            for csi_st_idx = 1:1:length(CSI_struct)     % all the structure
                CSI_entry = CSI_struct(1,csi_st_idx);
                N_tx = CSI_entry.nc;
                N_rx = CSI_entry.nr;
                N_tones = CSI_entry.num_tones;
                pay_len = CSI_entry.payload_len;
                pkt_cbn = CSI_entry.ant_cbn;
                pkt_rate = CSI_entry.rate;
                
                CSI = CSI_entry.csi;
                rssi_v(1,1) = CSI_entry.rssi_0;
                rssi_v(2,1) = CSI_entry.rssi_1;
                rssi_v(3,1) = CSI_entry.rssi_2;
                timestamp   = CSI_entry.timestamp; 

%                 mssend(sock_vec_out(2,1), 1);
                
                if (N_tx ~= n_txSS || N_rx ~= n_rxCH || N_tones ~= n_sc)
                    fprintf('MIMO config is not correct, skip this packet!\n');
                    mssend(sock_vec_out(2,1), 0);
                    continue
                end
                if isempty(CSI)
                    fprintf('CSI is empty, skip this packet!\n');
                    mssend(sock_vec_out(2,1), 0);
                    continue;
                end
                if ~isempty(find(rssi_v==255, 1))
                    fprintf('rssi is not correct, skip this packet!\n');
                    mssend(sock_vec_out(2,1), 0);
                    continue
                end
                if isempty(find(pkt_rate==rate_v, 1))
                    fprintf('rate is not correct, skip this packet!\n');
                    mssend(sock_vec_out(2,1), 0);
                    continue
                end
                
%                 csi_amp = abs(CSI);
%                 csi_t1r1_var = var(diff(abs(squeeze(CSI(1,1,:)))));
%                 if ~isempty(find(csi_amp==0, 1)) || csi_t1r1_var > 10000
%                     fprintf('CSI is not correct, skip this packet!\n');
%                     mssend(sock_vec_out(2,1), 0);
%                     continue
%                 end
% 
%                 % save trace for debugging
%                 dbg_cnt = dbg_cnt+1;
%                 dbg_csi_mat(dbg_cnt,:,:,:) = CSI;
%                 dbg_rssi_mat(dbg_cnt,:) = rssi_v;
%                 dbg_rate_mat(dbg_cnt,1) = pkt_rate;
%                 dbg_paylen_mat(dbg_cnt,1) = pay_len;
%                 dbg_timest_mat(dbg_cnt,1) = timestamp;
%                            
                if state == 0                    
                    % probing state
                    if ~isempty(find(pkt_cbn==probing_cbn,1))
                        prb_cnt = mod(pkt_cbn,4);
                        if prb_cnt == 0
                            prb_cnt = 4;
                        end
    
                        csiBuffer.CSI(prb_cnt,:,:,:) = CSI;
                        csiBuffer.RSSI(prb_cnt,:) = rssi_v;
                        csiBuffer.cbnIdx(prb_cnt) = pkt_cbn;
                        csiBuffer.tstamp(prb_cnt) = timestamp;

                        if(isempty(find(csiBuffer.RSSI==0,1)))  % make sure we get CSI from 4 probing combinations
%                             dbg_csiBuffer_cnt = dbg_csiBuffer_cnt+1;
%                             dbg_csiBuffer_v{dbg_csiBuffer_cnt,1} = csiBuffer;
                            
                            csiCbn_struct = antCbn_mapping(csiBuffer);
                            eSNRCbn_struct = eSNR_compute(csiCbn_struct);
                            eSNR_list = bestCbn_select(eSNRCbn_struct);
                            w_eSNR_series = eSNR_series_maintain(eSNR_list);
                            cbnIdx = systemStateCtrl(w_eSNR_series);
                           
                            bestCbn = cbnIdx;

                            fprintf('Selected best Cbn Idx is: %d\n', bestCbn);
                            mssend(sock_vec_out(2,1), bestCbn);
                            csiBuffer.RSSI = zeros(4,n_rxCH);   % set RSSI vec to 0 before next probing
                            
                            tstamp_cnt = tstamp_cnt+1;
                            tstamp_new_AC(tstamp_cnt,1) = timestamp;
                        else
                            % probing antenna in the Round-Robin manner
                            idx = find(pkt_cbn==probing_cbn);
                            if idx == 4
                                idx = 1;
                            else
                                idx = idx+1;
                            end
                            
                            fprintf('Current probing cbn is %d, switch to probing cbn %d\n', pkt_cbn, probing_cbn(idx));
                            mssend(sock_vec_out(2,1), probing_cbn(idx));
                        end
                    else
                        fprintf('Current cbn is not for probing, switch to the 1st probing cbn!\n');
                        mssend(sock_vec_out(2,1), 1);
                    end
                else  
                    % monitor state
                    if pkt_cbn ~= bestCbn
                        fprintf('Not using the selected best combination!\n');
                    end

                    csiStruct.CSI = CSI;
                    csiStruct.RSSI = rssi_v;
                    csiStruct.cbnIdx = pkt_cbn;
                    csiStruct.tstamp = timestamp;

                    eSNR_list = eSNR_compute(csiStruct);                    
                    current_esnr = eSNR_list.esnr_ori;
                    
                    esnr_cnt = esnr_cnt+1;
                    esnr_hist_cnt = esnr_hist_cnt+1;
                    if esnr_cnt <= 30
                        esnr_init(esnr_cnt,1) = current_esnr;
                        esnr_hist(esnr_hist_cnt,1) = current_esnr;
                        if esnr_cnt == 30
                            esnr_ref = mean(esnr_init);
                            esnr_last = esnr_ref;
                        end
                        state = 1;
                        cbnIdx = pkt_cbn;
                        
                        fprintf('Switch to cbn: %d\n', cbnIdx);
                        mssend(sock_vec_out(2,1), cbnIdx);
                    else
                        esnr_ewma = (1-wht)*esnr_last+wht*current_esnr;
                        esnr_hist(esnr_hist_cnt,1) = esnr_ewma;
                        diffe = abs(esnr_ewma-esnr_ref);
                        if ((diffe <= 50) && (esnr_ewma > 50))
                            esnr_last = esnr_ewma;
                            cbnIdx = pkt_cbn;
                            
                            pause(0.05);
                            
                            fprintf('Switch to cbn: %d\n', cbnIdx);
                            mssend(sock_vec_out(2,1), cbnIdx);
                        else
                            state = 0;
                            cbnIdx = 1;
                            
                            esnr_cnt = 0;
                            esnr_init = zeros(1,1);
                            
                            fprintf('Switch to cbn: %d\n', cbnIdx);
                            mssend(sock_vec_out(2,1), cbnIdx);
                        end
                    end
                    
%                     plot(esnr_hist,'k.-');
%                     drawnow;
                    
%                     if cbnIdx~= pkt_cbn
%                         fprintf('State shifts to probing!\n');
%                     end
% 
%                     fprintf('Switch to cbn: %d\n', cbnIdx);
%                     mssend(sock_vec_out(2,1), cbnIdx);
                end
%                 
% %                 state_cnt = state_cnt+1;
% %                 dbg_state_vec(state_cnt,1) = state;
% %                 subplot(3,2,1)
% %                 plot(hist_TP_series_top.series/10^6,'k.-');hold on
% %                 plot(hist_TP_series_inUse.series/10^6,'r.-');hold off
% %                 xlabel('time');ylabel('Throughput (Mbps)');
% %                 subplot(3,2,3)
% %                 plot(hist_TP_series_inUse.cbnIdx,'LineWidth',3);
% %                 ylim([1 64]);
% %                 xlabel('time');ylabel('cbnIdx');
% %                 subplot(3,2,5)
% %                 plot(dbg_state_vec,'k.-','LineWidth',3);
% %                 ylim([-1 2]);
% %                 xlabel('time');ylabel('state flag');
% %                 
% %                 drawnow

            end
        end
    end    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%            adjust the sockets 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sock_cnt_in     = sock_cnt_out;
    sock_vec_in     = sock_vec_out;
    sock_max        = max(sock_vec_in);
    sock_min        = min(sock_vec_in);    
    toc
end

for i = 1:1:length(sock_vec_out)
    fprintf('close all active socket and exit!!\n');
    msclose(sock_vec_out(i,1));
end
