function [spectro] = create_spectro(data, tle)
    % Plot spectrogram

    FFT_SIZE = 512;
    
    % calculates 75% overlap
    [~, f, t, ps] = spectrogram(data,kaiser(FFT_SIZE,8),round(0.75*FFT_SIZE),...
                                FFT_SIZE,1,'centered');
    p = db(ps,'power');
  
    figure()
        mesh(f,t,p.')
        xlim([-0.5 0.5])
        ylim([t(1) t(end)])
        view(2)
        cLimits = get(gca,'CLim');
        h = colorbar;
        x_tle = "f (Hz)";
        y_tle = "Midpoint of Window"; 
        z_tle = "Power/frequency (dB/Hz)";
        title(tle)
        xlabel(x_tle)
        ylabel(y_tle)
        ylabel(h,z_tle)

        spectro.r.f = f;
        spectro.r.t = t;
        spectro.r.p_dB = p;
        spectro.r.p = ps;
end