function [single_SVD] = time_SVD(r,options)
    SVD_VALUE = options.svdVal;
    m = options.frameSize; % Num Samples in each Segment
    OvFtr = 0.5; % Overlap Factor
    FFT_VALUE = options.fftSize; % For Spectrogram
    Plotting.Sensors = options.plotting.sensors;
    Plotting.SVD = options.plotting.svd;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [n, k] = size(r); % n samples by k sensors

    % Num Samples for Window Overlap
    win.m_ovr = m-round(m*OvFtr);
    win.window = repmat(hann(m,'periodic'),1,k);

    single_SVD = zeros(n,k);
    sv_th = zeros(ceil((n-win.m_ovr)/win.m_ovr),k);
    sv = zeros(ceil((n-win.m_ovr)/win.m_ovr),k);
    % use eigenvectors and values to combine sensors
    % currently unfinished
    e_val = zeros(ceil((n-win.m_ovr)/win.m_ovr),k);
    e_vec = zeros(ceil((n-win.m_ovr)/win.m_ovr),k,k);
    q = 0;
    for i = 1:win.m_ovr:(n-m)
        q = q + 1;
        if i+m <= n  
            [e_vec(q,:,:), e_val(q,:), sv(q,:),sv_th(q,:)] = analyzeGram(r(i:i+m-1,:),options);
            [single_SVD(i:i+m-1,:)] = single_SVD(i:i+m-1,:) + getSVD(r(i:i+m-1,:),SVD_VALUE).*win.window;   
        else
            [e_vec(q,:,:), e_val(q,:), sv(q,:),sv_th(q,:)] = analyzeGram(r(i:i+m-1,:),options);
            single_SVD(i:n,:) = single_SVD(i:n,:) + getSVD(r(i:n,:),SVD_VALUE).*win.window(1:n-i+1,:);
        end   
    end
    
    if Plotting.Sensors
        figure()
        sgtitle(sprintf("SVD Estimation for Singular Values: " + int2str(SVD_VALUE)))
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
        ylabel("Magnitude (dB)")
        xlabel("Frame Number")
    end
    
    if Plotting.SVD
        svd_plt = figure();
        plot_svd(sv, "")
        ylabel("Magnitude (log scale)")
        xlabel("Frame Number")
        saveas(svd_plt,"./SVD_with_FFT\figures\svd_filt"+num2str(options.nFilt)+".jpg")
    end

end