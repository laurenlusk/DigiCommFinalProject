function [single_SVD] = time_SVD(r,svdVal,frameSize,fftSize)
    SVD_VALUE = svdVal;
    m = frameSize; % Num Samples in each Segment
    OvFtr = 0.5; % Overlap Factor
    FFT_VALUE = fftSize; % For Spectrogram
    FILTER = 0; % Turns Filter On/Off
    Plotting.Sensors = 1;
    Plotting.SVD = 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath("./Data_Exploration");
    [n, k] = size(r); % n samples by k sensors

    % Lowpass Filter
    if FILTER
        r = filerSig(r, n, k);
    end

    % Num Samples for Window Overlap
    win.m_ovr = m-round(m*OvFtr);
    win.window = repmat(hann(m,'periodic'),1,k);

    single_SVD = zeros(n,k);
    e_val = zeros(ceil((n-win.m_ovr)/win.m_ovr),k);
    e_vec = zeros(ceil((n-win.m_ovr)/win.m_ovr),k,k);
    sv = zeros(ceil((n-win.m_ovr)/win.m_ovr),k);
    cRaw = zeros(ceil((n-win.m_ovr)/win.m_ovr),k*k);
    q = 0;
    for i = 1:win.m_ovr:(n-m)
        q = q + 1;
        if i+m <= n  
            [e_vec(q,:,:), e_val(q,:), sv(q,:)] = analyzeGram(r(i:i+m-1,:));
            [single_SVD(i:i+m-1,:)] = single_SVD(i:i+m-1,:) + getSVD(r(i:i+m-1,:),SVD_VALUE).*win.window;   
            [cRaw(q,:)] = corrData(r(i:i+m-1,:));
        else
            [e_vec(q,:,:), e_val(q,1:n-i+1), sv(q,1:n-i+1)] = analyzeGram(r(i:n,:));
            single_SVD(i:n,:) = single_SVD(i:n,:) + getSVD(r(i:n,:),SVD_VALUE).*win.window(1:n-i+1,:);
            [cRaw(q,:)] = corrData(r(i:n,:));
        end   
    end
    
    if Plotting.Sensors
        figure()
        sgtitle(sprintf("Time SVD Estimation for Singular Values: " + int2str(SVD_VALUE)))
        ax = zeros(k,1);
        cLimits = 0;
        for i = 1:k
            ax(i) = subplot(k/2,2,i);
            tle = sprintf("Sensor " + i);
            data = single_SVD(:,i);
            [spectro] = get_spectro(single_SVD(:,i),FFT_VALUE);
            [cLimits] = plot_spectro(spectro, cLimits, tle);
            %%%%%%%
            % [ContrastMatrix, center, REDUCE] = contrast_ratios(single_SVD(:,i),...
            %                                    options,win,spectro,i);
        end
    end
    
    if Plotting.SVD
        figure()
        plot_svd(sv, k, "Singular Values (Time Domain)")
    end

end