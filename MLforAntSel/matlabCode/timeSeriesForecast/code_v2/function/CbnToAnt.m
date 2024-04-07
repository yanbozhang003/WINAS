function [ch1AntIdx, ch2AntIdx, ch3AntIdx] = CbnToAnt(cbnIdx)

    ch3AntIdx = mod((cbnIdx-1),4)+1;
    tmp = floor((cbnIdx-1)/4);
    ch2AntIdx = mod(tmp,4)+1;
    tmp = floor(tmp/4);
    ch1AntIdx = mod(tmp,4)+1;
    
end

