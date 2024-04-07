clear;close all;clc
addpath('./function/effective snr source/');

% define data structure
sample_cnt = 0;
sample_num = 100000;
sample     = zeros(56,8,sample_num);
label      = zeros(1,sample_num);
while 1
    %% generate csi
    % global parameters
    center_freq  = 2.412*10^9;                                                  % channel 3 (Hz)
    delta_f      = 312.5*10^3;                                                  % subchannel interval (Hz)
    subc_idx     = -28:1:28;                                                    % remember to rm DC 
    freq_vec     = center_freq + subc_idx * delta_f;                            % subcarrier freq (Hz)
    freq_vec(29) = [];
    speed_light  = 3*10^8;                                                      % speed of light (m/s)
    lamda        = speed_light ./ freq_vec;
    D_antArray   = 0.07;                                                        % distance between antennas (m)
    Ant_idx      = 1:1:8;                                                       % antenna index of the array

    baseline_len = 12;                                                          % generate path length around this number (m)
    cylc_pre_len = 0.8*10^-6;                                                   % path length difference range (s)
    AoA_max      = pi;
    AoA_min      = 0;

    % obtain path specific parameters
    amp_range  = 1;                                                             % signal power range of different path will impact
    path_num   = 10;                                                            % how many paths are there
    amp_reduce_step = 5;                                                        % divide this step to the next path
    Path       = zeros(56,8,path_num);                                                
    airTime    = zeros(1,path_num); AoA = zeros(1,path_num); Amp = zeros(1,path_num); 
    airTime(1) = baseline_len / speed_light;
    for i = 1:path_num
        airTime(i) = airTime(1) + cylc_pre_len*rand(1,1);
        AoA(i) = pi * rand(1,1);
        Amp(i) = 10^amp_range * rand(1,1);
    %     Amp(i) = 10^amp_range * rand(1,1) / amp_reduce_step^(i-1);
    end

    % for path1
    for path_idx = 1:1:path_num
        airTime_ant = airTime(path_idx) + ((Ant_idx - 1) * D_antArray * sin(AoA(path_idx)))/speed_light;
        Path(:,:,path_idx) = Amp(path_idx)*exp(-1i*2*pi*freq_vec'*airTime_ant);
    end
    path_sum = sum(Path,3);

    % % test
    % amp = abs(path_sum);
    % plot(amp(:,1),'k.-');
    % drawnow; waitforbuttonpress

    %% compute eSNR with MIMO configuration 1x2
    % RxAnt1_idx = 1; RxAnt2_idx = 5; 
    % csi_RxAnt1 = path_sum(:,RxAnt1_idx);
    % csi_RxAnt2 = path_sum(:,RxAnt2_idx);
    % csi = cat(3, csi_RxAnt1, csi_RxAnt2);
    % csi = permute(csi, [2,3,1]);
    eSNR_vec = zeros(1,8);
    for i = 1:1:8
        csi = path_sum(:,i).';
        csi = reshape(csi,[1,1,56]);
        eSNR = get_eff_SNRs(csi*2);
        eSNR_vec(i) = eSNR(1,4);
    end
    % plot(eSNR_vec,'k.-')

    %% generate sample and label
    sample_cnt = sample_cnt + 1;
    [M,I] = max(eSNR_vec);
    sample(:,:,sample_cnt) = path_sum;
    label(sample_cnt) = I;

    if sample_cnt==sample_num
        break;
    end
end

save('../data/selfGenerated/ML_data.mat','sample','label');