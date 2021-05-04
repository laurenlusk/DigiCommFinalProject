clear all
close all 
load('./Datasets\snippet_11.mat', 'r')
addpath('./SVD_with_FFT');
addpath('./SVD_with_FFT/Success_Metric');

threshold = 1e100;
options.applyThreshold = 0;
options.applySingularVal = 1;
options.offset = 1;
options.nFilt = 1;

plt.energy = 0;
plt.contrastRatios = 1;

frameSize = 512;
fft_size = frameSize*2;
options.frameSize = frameSize;
options.fftSize = fft_size;

options.plotting.sensors = 1;
options.plotting.svd = 1;
Plotting.CombinedSensors = 0;

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

% options.svdVal = [1:8;4:8;3:4;4];
num = 4;
ContrastMatrix = zeros(num,8,3);

for x = 1:num
    if x==1
        options.svdVal = 1:8;
    elseif x==2
        options.svdVal = 4:8;
    elseif x==3
        options.svdVal = 3:4;
    else
        options.svdVal = 4;
    end
    if options.applySingularVal
        options.title = "values: " + int2str(options.svdVal);
    end
    [single_SVD] = time_SVD(sensors,options);
    y_time = sum(single_SVD,2);

    [spectro_time] = create_spectro(y_time.',"Time SVD Estimation");
    [ContrastMatrix(x,1:8,1:3), tmpCenter, tmpREDUCE] = Contrast_Ratios(y_time.',options,win,spectro_time);
end

if plt.contrastRatios
    options.legendLabels = ["Singular Values 1-8","Singular Values 4-8",...
                            "Singular Values 3-4","Singular Value 4"];
    plot_contrast_matrix(ContrastMatrix, options);
end
