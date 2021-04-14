function [spectro] = create_spectro(r, r_est, options)
    % Plot spectrogram for original channel and absolute error of estimated
    % channel
    % r: True Recieved Channels (row vector)
    % r_est: Estimated recieved channel (row vector)

    FFT_SIZE = 512;
    
    % calculates 75% overlap
    [~, f, t, ps] = spectrogram(r,kaiser(FFT_SIZE,8),round(0.75*FFT_SIZE),...
                                FFT_SIZE,1,'centered');
    p = db(ps,'power');

        figure(options.offset)
        ax(1) = subplot(2,1,1);
            mesh(f,t,p.')
            xlim([-0.5 0.5])
            ylim([t(1) t(end)])
            view(2)
            cLimits = get(gca,'CLim');
            h = colorbar;
            tle_1 = sprintf("Channel " + int2str(options.sensorNum));
            x_tle = "f (Hz)";
            y_tle = "Midpoint of Window"; 
            z_tle = "Power/frequency (dB/Hz)";
            title(tle_1)
            xlabel(x_tle)
            ylabel(y_tle)
            ylabel(h,z_tle)

            spectro.r.f = f;
            spectro.r.t = t;
            spectro.r.p_dB = p;
            spectro.r.p = ps;
            
	[~, f, t, ps] = spectrogram(r-r_est,kaiser(FFT_SIZE,8),...
                    round(0.75*FFT_SIZE),FFT_SIZE,1,'centered');
     p = db(ps,'power');
     
 
        ax(2) = subplot(2,1,2);

            mesh(f,t,p.')
            xlim([-0.5 0.5])
            ylim([t(1) t(end)])
            view(2)
            caxis(cLimits);
            h = colorbar;
            tle_2 = "Residuals: " + int2str(options.numOfTapers) + ...
                " Tapers Added to Channel " + int2str(options.tapersSensorNum);
            title(tle_2)
            xlabel(x_tle)
            ylabel(y_tle)
            ylabel(h,z_tle)

            linkaxes(ax,'xy')
            zoom on

            spectro.rError.f = f;
            spectro.rError.t = t;
            spectro.rError.p_dB = p;
            spectro.rError.p = ps;
end