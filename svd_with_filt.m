clear all
close all 
load('./Datasets\snippet_14.mat', 'r')
addpath('./SVD_with_FFT');
addpath('./SVD_with_FFT/Success_Metric');

options.frameSize = 512;
options.fftSize = options.frameSize*2;
threshold = 1e100;
nChan = 20;
options.svdVal =  3:4;

options.applyThreshold = 0;
options.applySingularVal = 0;
applyFilter = 1;
options.offset = 1;

options.plotting.sensors = 0;
options.plotting.svd = 1;
Plotting.CombinedSensors = 0;
Plotting.contrastRatios = 0;

options.REDUCE.N = 1;
options.REDUCE.S = 1;
options.REDUCE.E = 1;
options.REDUCE.W = 1;
options.center = [202, 224; 310, 396];

options.TOL = 0.05; % Affects buffer size between rectangles 
options.ANNOTATE = 0;
options.success.cardinal = 0.75;
options.success.diagonals = 0.25;
options.q = 1;
options.title = "";
if options.applySingularVal
    options.title = "values: " + int2str(singularVal);
end

ContrastMatrix = zeros(nChan,8,3);
r = r.' ; % making a “tall” matrix with 8 columns and a large number of rows

for x = 1:nChan
    
    if applyFilter
        BW = 1/nChan; DEC = floor(1/BW)-1; % DEC preferably slightly smaller than 1/BW
        fctr = x/nChan; % for a lowpass filter, but it can be anywhere in the range [-0.5+BW/2 0.5-BW/2]
        FILTER = 1 ; % turns bandpass filtering operation ON (=1) or OFF(=0)
        ford = 80 ; % filter order (essentially controls rolloff and stopband attenuation

        h = firpm(ford,[0 BW/2 BW/2+0.05 .5]*2,[1 1 0 0]);
        h = h.*exp(1j*2*pi*fctr*[0:ford]);
        nfft = 2^18;
        filt_plt = figure();
        [H]=freqz(h,1,nfft,'whole',1) ;
        ff = [0:(nfft-1)]/nfft - 0.5;
        plot(ff,db(fftshift(H)))
        saveas(filt_plt,"SVD_with_FFT\figures\filt"+num2str(x)+".jpeg")
        [n,k] = size(r) ;
        rr = zeros(size(r));
        for col=1:k
            rr(:,col) = filter(h,1,r(:,col)) ;
        end
        sensors = rr(1:DEC:end,:) ; % decimate the time domain data
    else
        sensors = r;
    end
    options.nFilt = x;
    [single_SVD] = time_SVD(sensors,options);
    y_time = sum(single_SVD,2);

    if Plotting.CombinedSensors
        [spectro_time] = create_spectro(y_time.',"Time SVD Estimation");
    end
end

