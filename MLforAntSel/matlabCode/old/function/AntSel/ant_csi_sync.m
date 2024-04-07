
% input: 
%   csi_matrix, 5-D: (RxChain_idx, subc_idx, mcs_idx, pkt_idx, cbn_idx)
%   tx_num: the number of in use transmit chain
%   rx_num: the number of in use receiver chain
%   ant_num: the number of antennas for each chain at Rx

% output: csi_ant, 2-D: (RxChain, ant_idx);

function ret = ant_csi_sync(csi_matrix, rx_num, ant_num, len_CSIperAnt)
    csi_ant = zeros(rx_num, ant_num, 56, len_CSIperAnt);
    
    % Tx=1, Rx=1, antenna from 1 to 4
    csi_ant_tmp  = squeeze([csi_matrix(1,:,:,:,2),csi_matrix(1,:,:,:,8),csi_matrix(1,:,:,:,10),csi_matrix(1,:,:,:,16)]);
    csi_ant(1,1,:,:) = reshape(csi_ant_tmp,56,[]);
    csi_ant(1,2,:,:) = reshape(squeeze([csi_matrix(1,:,:,:,4),csi_matrix(1,:,:,:,6),csi_matrix(1,:,:,:,12),csi_matrix(1,:,:,:,14)]),56,[]);
    csi_ant(1,3,:,:) = reshape(squeeze([csi_matrix(1,:,:,:,1),csi_matrix(1,:,:,:,3),csi_matrix(1,:,:,:,9),csi_matrix(1,:,:,:,11)]),56,[]);
    csi_ant(1,4,:,:) = reshape(squeeze([csi_matrix(1,:,:,:,5),csi_matrix(1,:,:,:,7),csi_matrix(1,:,:,:,13),csi_matrix(1,:,:,:,15)]),56,[]);
    
    % Tx=1, Rx=2, antenna from 1 to 4
    csi_ant(2,1,:,:) = reshape(squeeze([csi_matrix(2,:,:,:,1),csi_matrix(2,:,:,:,4),csi_matrix(2,:,:,:,5),csi_matrix(2,:,:,:,16)]),56,[]);
    csi_ant(2,2,:,:) = reshape(squeeze([csi_matrix(2,:,:,:,8),csi_matrix(2,:,:,:,9),csi_matrix(2,:,:,:,12),csi_matrix(2,:,:,:,13)]),56,[]);
    csi_ant(2,3,:,:) = reshape(squeeze([csi_matrix(2,:,:,:,2),csi_matrix(2,:,:,:,3),csi_matrix(2,:,:,:,6),csi_matrix(2,:,:,:,7)]),56,[]);
    csi_ant(2,4,:,:) = reshape(squeeze([csi_matrix(2,:,:,:,10),csi_matrix(2,:,:,:,11),csi_matrix(2,:,:,:,14),csi_matrix(2,:,:,:,15)]),56,[]);
    
    ret = csi_ant;
end