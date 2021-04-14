function c = corrSV(sv)

    [n, k] = size(sv);
    
    m = 20; % FrameSize
    OvFtr = 0.5; % Overlap Factor
    win.m_ovr = m-round(m*OvFtr);
    % win.window = repmat(hann(m,'periodic'),1,k);
    c = zeros(ceil((n-win.m_ovr)/win.m_ovr), k*k);
    
    q = 0;
    for i = 1:win.m_ovr:(n-m)
        q = q + 1;
        if i+m <= n  
            c(q,:) = reshape(corr(sv(i:i+m-1,:)), 1, []);
        else
            c(q,:) = reshape(corr(sv(i:n,:)), 1, []);
        end   
    end
    
end
