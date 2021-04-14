function C_new = normalizeCoeff(C, k)

    C_new = repmat(C, 1, k);

    for i = 1:k
        C_new(:,i) = C_new(:,i)/ C_new(i,i);
    end

end