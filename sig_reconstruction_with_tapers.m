clear all
close all
load('.\Datasets/snippet_11.mat', 'r')
addpath('./sig_reconstruction_with_tapers');
addpath('./sig_reconstruction_with_tapers/Success_Metric');

frameSize = 1024;
time_halfBW = 1;
nTapers = 10;
% tapers to look at
tapNum = [0 4 6];
taperSensors = 0:7;
% for now, count anything above the real sensor num as #-1
% ex. sensorNum = 5; then sensor 7 is 6 and sensor 8 is 7
remove.sensor = 0;
remove.coeff = 0;
options.offset = 1;
% maxTaperNum = 10;

options.dataset = 11;
options.changeNumTapers = 1;
options.changeSensor = 0;
options.sensorNum = 5;
plt.energy = 0;

options.REDUCE.N = 1;
options.REDUCE.S = 1;
if options.dataset == 5
    options.REDUCE.E = 0.851852;
    options.center = [274 126; 301 308];
elseif options.dataset == 3
    options.REDUCE.E = 1;
    options.center = [274 244; 301 375];
else
    options.REDUCE.E = 1;
    options.center = [202, 224; 310, 396];
end
options.REDUCE.W = 1;
options.TOL = 0.05;
options.ANNOTATE = 0;
options.success.cardinal = 0.75;
options.success.diagonals = 0.25;
options.q = 1;
options.title = "dataset " + int2str(options.dataset) + ", halfBW " + string(time_halfBW);
if remove.coeff
    options.title = options.title + ", ignore coeff";
end
if remove.sensor
    options.title = options.title + ", ignore sensor";
end
options.ylim = [0 35];

base_sensors = r.';
base_sensors(:,options.sensorNum) = [];
true_sensor = r(options.sensorNum,:).';

frames = floor(length(true_sensor)/frameSize);
nFrames = 2*frames;
overlap = frameSize/2;
win = windows(overlap);

window = hann(frameSize,'periodic');
[taper_seq,lambda] = dpss(frameSize,time_halfBW,nTapers);

num = 7;
ContrastMatrix = zeros(num,8,3);

y_total = zeros(size(base_sensors));
n = 1;
for itter = tapNum + 1
    
    options.n = n;
    if itter ==1
        options.numOfTapers = 0;
        options.tapersSensorNum = 0;
    else
        if options.changeSensor
            options.numOfTapers = maxTaperNum;
            options.tapersSensorNum = itter-1;
        else
            options.numOfTapers = itter-1;
            options.tapersSensorNum = taperSensors;
        end
    end
    
    est_sensors = base_sensors;
    if remove.sensor
        if options.tapersSensorNum > 0
            est_sensors(:,options.tapersSensorNum) = 0;
        end
    end

    ySegmented = zeros(size(est_sensors));
    svd = zeros(size(est_sensors));
    C = zeros(size(est_sensors,2),nFrames-1);
    for i=1:nFrames-1      
        indx = 1+(i-1)*overlap;
        framed_estimators = est_sensors(indx:indx+frameSize-1,:);
        framed_sensor = true_sensor(indx:indx+frameSize-1);
        framed_estimators_mod = framed_estimators;
        framed_sensor_mod = framed_sensor;
        
        if itter > 1
            tapers = prod(taper_seq(:,1:itter-1),2);
            for s = 1:7
                framed_estimators_mod(:,s) = ...
                                framed_estimators_mod(:,s).*tapers;
            end
            framed_sensor_mod = framed_sensor_mod.*tapers;
        end

        c = fft(framed_estimators_mod,2^12)\fft(framed_sensor_mod,2^12); % zero pad
        if remove.coeff
            if options.tapersSensorNum > 0
                c(options.tapersSensorNum) = 0;
            end
        end
        C(:,i) = c; 

        if i == 1
            ySegmented(i:i+frameSize-1,:) = ySegmented(i:i+frameSize-1,:) + ...
                framed_estimators.*c.'.*[ones(length(window)/2,1);window(length(window)/2+1:end)];         
        else
            if indx + frameSize >= length(true_sensor)
                ySegmented(indx:end,:) = ySegmented(indx:end,:)+...
                    framed_estimators.*c.'.*[window(1:length(window)/2);ones(length(window)/2,1)];

            else
                ySegmented(indx:indx+frameSize-1,:) = ySegmented(indx:indx+frameSize-1,:)+...
                    framed_estimators.*c.'.*window;
            end
        end
    end
    
    y = sum(ySegmented,2);

    y_total(:,n) = y;
    
    [spectro] = create_spectro(true_sensor.',y.',options);
    options.offset = options.offset + 1;
    [ContrastMatrix(itter,1:8,1:3), tmpCenter, tmpREDUCE] = Contrast_Ratios(true_sensor.',y.',options,win,spectro,1);
    if (itter == 1) 
        if ~isequal(options.center,tmpCenter)
            options.center = tmpCenter;
        end
        if ~isequal(options.REDUCE,tmpREDUCE)
            options.REDUCE = tmpREDUCE;
        end
    end


    if options.tapersSensorNum >= options.sensorNum
        options.tapersSensorNum = options.tapersSensorNum+1;
    end
    
    if plt.energy
        figure(options.offset)
        plot(abs(ySegmented))
        title(int2str(options.numOfTapers)+" Tapers (" + options.title + ")")
        options.offset = options.offset + 1;
    end
    
%     figure(options.offset+3*n)
%     plot(svd)
%     title("SVD")
%     options.offset = options.offset + 1;
    
    save(strcat(fullfile(pwd,'sig_reconstruction_with_tapers','contrast_matrix'),'\contrastMatrix.mat'),'ContrastMatrix')
    
    nfft = 2^18;
    [orig ff2] = freqz((true_sensor),1,nfft,'whole',1);
    [reCon ff2] = freqz((y),1,nfft,'whole',1);
    [res ff2] = freqz((true_sensor-y),1,nfft,'whole',1);
    ff2 = -nfft/2:nfft/2-1;
    ff2 = ff2/nfft;

    figure(options.offset)
    plot(ff2, fftshift(db(orig)),'b')
    hold on
    plot(ff2, fftshift(db(reCon)),'c')
    plot(ff2, fftshift(db(res)),'r')
    hold off
    legend({'Original','Reconstructed','Residuals'})
    title("Original & Reconstructed Signals in Freq Domain (" + options.title + ", Tapers " +...
        int2str(options.numOfTapers) + ")")
    xlim([-0.2 0.2])
    ylim([-20 120])
    options.offset = options.offset + 1;
    
%     [reCon2 ff2] = freqz(abs(ySegmented(:,1)),1,2^18,'whole',1);
%     [orig2 ff2] = freqz(abs(est_sensors(:,1)),1,2^18,'whole',1);
%     [res2 ff2] = freqz(abs(est_sensors(:,1)-ySegmented(:,1)),1,2^18,'whole',1);
% 
%     figure(options.offset)
%     plot(ff2, 20*log10(abs(orig2)),'b')
%     hold on
%     plot(ff2, 20*log10(abs(reCon2)),'c')
%     plot(ff2, 20*log10(abs(res2)),'r')
%     hold off
%     legend({'Original','Reconstructed','Residuals'})
%     title("Sensor 4 in Freq Domain (" + options.title + ", Tapers " +...
%         int2str(options.numOfTapers) + ")")
%     options.offset = options.offset + 1;
%     
    n = n+1;
end

plot_contrast_matrix(ContrastMatrix, options);


% resT = orig_sensor - y;
% figure()
% spectrogram(resT,hann(512),256,'centered')
% title('First 7 Tapers Applied to Sensor 1')

