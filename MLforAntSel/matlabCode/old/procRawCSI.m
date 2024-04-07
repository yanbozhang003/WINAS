clear;
addpath('./function/csi tool function/');

for tr_idx = 1:1:2
    fileName = ['./data/raw/tst/tr',num2str(tr_idx),'.txt'];
    data = read_log_file(fileName);

    pkt_num = length(data);
    rxAnt_num = data{1,1}.nr;
    txAnt_num = data{1,1}.nc;
    subc_num  = 56;
    csi       = zeros(rxAnt_num,txAnt_num,subc_num,pkt_num);
    rssi      = zeros(4,pkt_num);


    for i = 1:1:pkt_num
        csi_tmp = data{i,1}.csi;
        rssi_1  = data{i,1}.rssi1;
        rssi_2  = data{i,1}.rssi2;
        rssi_3  = data{i,1}.rssi3;
        rssi_ttl  = data{i,1}.rssi;
        payl_len  = data{i,1}.payload_len;

        if isempty(csi_tmp)
            continue
        end

        if rssi_ttl == 0
            continue
        end

        if payl_len < 500 || payl_len > 600
            continue
        end

        csi(:,:,:,i) = csi_tmp;
        rssi(1:4,i)  = [rssi_1,rssi_2,rssi_3,rssi_ttl];
    end

    save(['./data/mat/tst/tr',num2str(tr_idx),'.mat'],'csi','rssi');

end