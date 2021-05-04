clear all
close all 
load('./Datasets\snippet_11.mat', 'r')
addpath('./SVD_with_FFT');
addpath('./SVD_with_FFT/Success_Metric');

threshold = 1e100;
singularVal = 4:5;
applyThreshold = 0;
applySingularVal = 0;
options.offset = 1;
options.nFilt = 1;

plt.energy = 0;
plt.contrastRatios = 1;

frameSize = 512;
fft_size = frameSize*2;
options.frameSize = frameSize;
options.fftSize = fft_size;

options.plotting.sensors = 0;
options.plotting.svd = 1;
Plotting.CombinedSensors = 0;

options.REDUCE.N = 1;
options.REDUCE.S = 1;
options.REDUCE.E = 1;
options.REDUCE.W = 1;
options.center = [202, 224; 310, 396];;

options.TOL = 0.05; % Affects buffer size between rectangles 
options.ANNOTATE = 0;
options.success.cardinal = 0.75;
options.success.diagonals = 0.25;
options.q = 1;
options.title = "";
options.applyThreshold = applyThreshold;
options.applySingularVal = applySingularVal;
options.svdVal =  singularVal;
if applyThreshold
    options.title = "threshold of " + int2str(threshold);
end
if applySingularVal
    options.title = "values: " + int2str(singularVal);
end

sensors = r.';
[m,k] = size(sensors);

frames = floor(m/frameSize);
nFrames = 2*frames;
overlap = frameSize/2;
win = windows(overlap);

window = hann(frameSize,'periodic');

num = 2;
ContrastMatrix = zeros(num,8,3);

ySegmented = zeros(size(sensors));
C = zeros(size(sensors,2),nFrames-1);
sv = zeros(nFrames,k);
n = 1;

for i=1:nFrames-1  
%     for i=1:2
    indx = 1+(i-1)*overlap;
    framed_sensors = sensors(indx:indx+frameSize-1,:);

    if i == 1
        y_seg = ...
            framed_sensors.*[ones(length(window)/2,1);window(length(window)/2+1:end)];         
    else
        if indx + frameSize >= length(sensors)
            y_seg = ...
                framed_sensors.*[window(1:length(window)/2);ones(length(window)/2,1)];

        else
            y_seg = framed_sensors.*window;
        end
    end
    
    y_fft = fft(y_seg,fft_size); % zero pad
    [U,So,V] = svd(y_fft);
    S = zeros(size(So));
    
    if applySingularVal
        for p = singularVal
           sv(n,p) = So(p,p);
           S(p,p) = So(p,p);
        end
    elseif applyThreshold
        for p = 1:k
           if So(p,p) < threshold
               S(p,p) = So(p,p);
           end
            sv(n,p) = S(p,p);
        end
    else
        S = So;
        for p = 1:k
            sv(n,p) = S(p,p);
        end
    end
    
    y_temp = U*S*V';
    
    y_ifft = ifft(y_temp);
    y_ifft = y_ifft(1:frameSize,:);
    
    if i == 1
        ySegmented(i:i+frameSize-1,:) = ySegmented(i:i+frameSize-1,:) + ...
            y_ifft;         
    else
        if indx + frameSize >= length(sensors)
            ySegmented(indx:end,:) = ySegmented(indx:end,:)+ y_ifft;

        else
            ySegmented(indx:indx+frameSize-1,:) = ySegmented(indx:indx+frameSize-1,:)+y_ifft;
        end
    end
    n = n+1;
end

y_freq = sum(ySegmented,2);
[single_SVD] = time_SVD(sensors,options);
y_time = sum(single_SVD,2);

figure()
semilogy(sv)
title("Singular Values (Freq Domain)")

figure()
sgtitle("Freq SVD Estimation for Singular Values" + " (" + options.title + ")")
ax = zeros(k,1);
cLimits = 0;
for i = 1:k
    ax(i) = subplot(k/2,2,i);
    tle = sprintf("Sensor " + i);
    data = ySegmented(:,i);
    options.sensorNum = i;
    [spectro] = get_spectro(data,fft_size);
    [cLimits] = plot_spectro(spectro, cLimits, tle);
end

[spectro_freq] = create_spectro(y_freq.',"Freq SVD Estimation");
[spectro_time] = create_spectro(y_time.',"Time SVD Estimation");

if plt.contrastRatios
    [ContrastMatrix(1,1:8,1:3), tmpCenter, tmpREDUCE] = Contrast_Ratios(y_freq.',options,win,spectro_freq);
    [ContrastMatrix(2,1:8,1:3), tmpCenter, tmpREDUCE] = Contrast_Ratios(y_time.',options,win,spectro_time);
    
    plot_contrast_matrix(ContrastMatrix, options);
end
