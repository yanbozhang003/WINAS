clear; close all;clc
load('../data/selfGenerated/ML_data.mat');

label = label';

sample_amp   = abs(sample);
sample_angle = angle(sample);

% feature scaling
for i = 1:1:56
    for x = 1:1:8
        sample_amp_tmp = squeeze(sample_amp(i,x,:));
        amp_tmp_mean = mean(sample_amp_tmp);
        amp_tmp_std = std(sample_amp_tmp);
        sample_amp_new = (sample_amp_tmp - amp_tmp_mean) / amp_tmp_std;
        sample_amp(i,x,:) = sample_amp_new;
    end
end
for i = 1:1:56
    for x = 1:1:8
        sample_pha_tmp = squeeze(sample_angle(i,x,:));
        pha_tmp_mean = mean(sample_pha_tmp);
        pha_tmp_std = std(sample_pha_tmp);
        sample_pha_new = (sample_pha_tmp - pha_tmp_mean) / pha_tmp_std;
        sample_angle(i,x,:) = sample_pha_new;
    end
end

sample = cat(4, sample_amp, sample_angle);
sample = permute(sample, [3,1,2,4]);
[n_sample, n_subc, n_ant, n_c] = size(sample);

%% sample size mapping: (56,8,2) to (64, 64, 2)
sample_reSize = zeros(n_sample, 64, 64, 2);

for i = 1:1:n_ant
    sample_reSize(:, 4:31, 1+8*(i-1), :) = sample(:, 1:28, i, :);
    sample_reSize(:, 33:60, 1+8*(i-1), :) = sample(:, 29:56, i, :);
end

% interpolation
for x = 1:1:n_sample
    for y = 1:1:n_subc
        for z = 1:1:n_c
            v = squeeze(sample(x,y,:,z));
            xq = (1+1/(n_ant+1)):1/(n_ant+1):(8-1/(n_ant+1));
            vq = interp1(v, xq);
            sample_reSize(x,y,1,z) = v(1,1);
            sample_reSize(x,y,64,z) = v(8,1);
            sample_reSize(x,y,2:1:63,z) = vq;
        end
    end
    disp(x);
end
sample = sample_reSize;

%% pick out some values
X_train = sample(1:30000,:,:,:);
Y_train = label(1:30000,1);
X_test = sample(60001:65000,:,:,:);
Y_test = label(60001:65000,:,:,:);
save('../data/selfGenerated/MLdataCNN.mat','X_train','Y_train','X_test','Y_test');


