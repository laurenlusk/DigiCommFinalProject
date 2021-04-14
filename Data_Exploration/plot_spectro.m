function [cLimits] = plot_spectro(spectro, cLimits, Title)

    mesh(spectro.f,spectro.t,spectro.p)
    xlim([-0.5 0.5])
    ylim([spectro.t(1) spectro.t(end)])
    view(2)
    if cLimits == 0
    	cLimits = get(gca,'CLim');
    else
    	caxis(cLimits);
    end
    h = colorbar;
    x_tle = "f (Hz)";
    y_tle = "Midpoint of Window"; 
    z_tle = "Power/frequency (dB/Hz)";
    title(Title)
    xlabel(x_tle)
    ylabel(y_tle)
    ylabel(h,z_tle)
    
end