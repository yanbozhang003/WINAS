function [after_csi] = rm_sm(before_csi)

[nr nc tone] = size(before_csi);

if nc == 3
    Q = [1 1 1; ...
        1 exp(1i*(-2*pi/3)) exp(1i*(-4*pi/3)); ...
        1 exp(1i*(-4*pi/3)) exp(1i*(-8*pi/3))];    
elseif nc == 2
    Q = [1 1; ...
         1 -1];         
end


for k = 1:tone
    after_csi(:,:,k) = before_csi(:,:,k) * inv(Q);
end