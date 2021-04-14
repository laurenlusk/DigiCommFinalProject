function [cRaw] = corrData(data)

    cRaw = reshape(corr(data), 1, []);
    
end