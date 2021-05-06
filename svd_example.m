clear all
close all 
load('./Datasets\snippet_11.mat', 'r')
addpath('./SVD_with_FFT');
addpath('./SVD_with_FFT/Success_Metric');

sensorNum = 1;
svdStartStop = [1 8;...
                3 8; ...
                4 8; ...
                3 4; ...
                4 4];

threshold = 1e100;
options.applyThreshold = 0;
options.applySingularVal = 0;
options.offset = 1;
options.nFilt = 0;

plt.energy = 0;
plt.contrastRatios = 1;

frameSize = 512;
fft_size = frameSize*2;
options.frameSize = frameSize;
options.fftSize = fft_size;

options.plotting.sensors = 0;
options.plotting.svd = 0;

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

sensors = r.';
[m,k] = size(sensors);

frames = floor(m/frameSize);
nFrames = 2*frames;
overlap = frameSize/2;
win = windows(overlap);

num = size(svdStartStop,1);
ContrastMatrix = zeros(num,8,3);

for x = 1:num
    options.svdVal = svdStartStop(x,1):svdStartStop(x,2);
    if options.applySingularVal
        options.title = "values: " + int2str(options.svdVal);
    end
    [single_SVD] = time_SVD(sensors,options);
    y_time = single_SVD(:,sensorNum);
%     y_time = sum(single_SVD,2);

    [spectro_time] = create_spectro(y_time.',"SVD Estimation");
    [ContrastMatrix(x,1:8,1:3), tmpCenter, tmpREDUCE] = Contrast_Ratios(y_time.',options,win,spectro_time);
end

if plt.contrastRatios
    for i=1:length(svdStartStop)
        if i==1
            if svdStartStop(i,1) == svdStartStop(i,2)
                options.legendLabels = num2str(svdStartStop(i,1));
            else
                options.legendLabels = num2str(svdStartStop(i,1))+"-"+num2str(svdStartStop(i,2));
            end
        else
            if svdStartStop(i,1) == svdStartStop(i,2)
                options.legendLabels = [options.legendLabels (...
                num2str(svdStartStop(i,1)))];
            else
                options.legendLabels = [options.legendLabels (...
                    num2str(svdStartStop(i,1))+"-"+num2str(svdStartStop(i,2)))];
            end
        end
    end
    plot_contrast_matrix(ContrastMatrix, options);
end
