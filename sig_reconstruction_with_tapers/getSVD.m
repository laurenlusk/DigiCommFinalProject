function [M] = getSVD(data)

    [U,S,V] = svd(data);
    [m, n] = size(data);
%     M = zeros(m,n);
%     for i = indx
%         M = M + S(i,i)*U(:,i)*V(:,i)';
%     end
    M = S*U*V.';
end