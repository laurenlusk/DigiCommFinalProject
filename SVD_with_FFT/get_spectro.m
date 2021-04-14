function [spectro] = get_spectro(data,FFT_VALUE)

    [~, f, t, ps] = spectrogram(data,kaiser(FFT_VALUE,8),round(0.75*FFT_VALUE),...
                                FFT_VALUE,1,'centered');

    p = db(ps,'power');

    spectro.p = p.';
    spectro.f = f;
    spectro.t = t;

end