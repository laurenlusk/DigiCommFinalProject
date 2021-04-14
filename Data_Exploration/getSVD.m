function [M] = getSVD(data,indx)

    [U,S,V] = svd(data);
    [m, n] = size(data);
    M = zeros(m,n);
    for i = indx
        a = S(i,i)*U(:,i)*V(:,i)';
        M = M + a;
    end
        
end