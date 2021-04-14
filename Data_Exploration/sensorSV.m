function [sv] = sensorSV(data)

    % gram = data'*data;
    [U,S,V] = svd(data);
    [m, k] = size(data);
    
    sv = zeros(k,k);
    for i = 1:k
        a = S(i,i)*U(:,i)*V(:,i)';
        % sv(i,1:k) = 
    end
    sv = 0;
end