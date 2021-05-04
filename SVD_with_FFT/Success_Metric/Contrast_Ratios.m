function [ContrastMatrix, center, REDUCE] = Contrast_Ratios(r,options,win,spectro)
 
    % spectro: struct of spectrogram generated values 
    %         (generated in plot_spectrogram)
    % ANNOTATE: bool to control plotting of rectangular areas (1 to plot)
    % center: (optional) should hold user defined diagonal points for
    %          center rectangle, required format: [x1, y1; x2, y2]
    % ContrastMatrix: contrast ratios for every box, with every statistic
    %                 Rows: boxes 2-9; Columns: Average, Median, Average of Middle 90%
    % center: contains center area points, to be put in vargin for next 
    %         function run, if desired.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % contrast_ratios.m returns matrix of contrast ratios (like SNR) for the 8 
    % rectangles surrounding a defined center rectangle of interest. The center
    % rectangle diagonal points, if not designated in the function input as the
    % third argument, can be chosen graphically (will need for spectrogram plot
    % to be the last active window). After running, press ENTER to continue if
    % plot annotations were chosen.

    % REDUCE:
    % Percentages to reduce the size of the rectangles surrounding the 
    % center rectangle, specific for each cardinal direction
    % Each reduction value should be defined for [0,inf), where 1 is the
    % same length as the center box

    TOL = options.TOL; % Affects buffer size between rectangles 
    REDUCE = options.REDUCE;
    ANNOTATE = options.ANNOTATE;
    
    input_checking(REDUCE, TOL);

    N = length(r);
    [center] = obtain_center(options.center, spectro);
    [f_indx, n_indx] = calc_locations(center, REDUCE, TOL, spectro,win,N);
    if (ANNOTATE)
        create_spectro(r, options);
        H = gcf;
        MAX_PWR = max(spectro.r.p_dB,[],'all');
        plot_Boxes(f_indx, n_indx, MAX_PWR, spectro, H);
    end

    Average = zeros(8,1);
    Median = zeros(8,1);
    Middle_90_Percent = zeros(8,1);

    k = 1;
    for i = 1:2:(2*9-1)
        % Chosen Rectangular Area
        A = spectro.r.p(f_indx(i):f_indx(i+1),n_indx(i):n_indx(i+1));
        %%%%%%%%%%%%%%  
        Area.("Rec_"+int2str(k)).pAvg = mean(A,'all');
        %%%%%%%%%%%%%%   
        Area.("Rec_"+int2str(k)).pMed = median(A,'all');
        %%%%%%%%%%%%%%
        p = [0.05 0.95]; % Averaging Everything Between Quantiles
        q = quantile(A,p,'all'); 
        A = reshape(A,[],1);
        indx = (A >= q(1))&(A <= q(2));
        Aorder = A(indx);
        Area.("Rec_"+int2str(k)).pOrder = mean(Aorder,'all');
        %%%%%%%%%%%%%%
        
        if (k>1) % Calculating Statistics for Surrounding Boxes
            Average(k-1) = Area.Rec_1.pAvg./Area.("Rec_"+int2str(k)).pAvg;
            Median(k-1) = Area.Rec_1.pMed./Area.("Rec_"+int2str(k)).pMed;
            Middle_90_Percent(k-1) = Area.Rec_1.pOrder./Area.("Rec_"+int2str(k)).pOrder;
        end
        
        k = k+1;
    end
    
    % Create Matrix Table (not in dB, but ps)
    ContrastMatrix = [Average, Median, Middle_90_Percent];

end