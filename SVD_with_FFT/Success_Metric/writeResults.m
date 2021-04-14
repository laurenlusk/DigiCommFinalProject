function writeResults(file, ContrastMatrix, options, win, Change)

    if (options.q == 1) % First Trial
        center = options.center;
        reduce = options.REDUCE;
        save(file.Center,'center','reduce');
        
        fprintf(file.ID, "Parameter (Parameter Filename): %s",strcat(file.Parameter,'.mat'));
        fprintf(file.ID, "\nData (Data Filename): %s",options.Data);
        fprintf(file.ID, "\nStartTime (Program Start Time): %s",file.StartTime);
        fprintf(file.ID, "\nHash (Last GIT Hash): %s",file.Hash);
        fprintf(file.ID, "\nTOL (success metric box buffer): %s",options.TOL);
        if Change.REDUCE
            fprintf(file.ID, "\nNOTE: REDUCE value changed manually during first trial.");
            fprintf(file.ID, "\n\tREDUCE (success metric reduction in each direction): [N, S, W, E] = [%g, %g, %g, %g]",options.REDUCE.N, options.REDUCE.S, options.REDUCE.W, options.REDUCE.E);
        else
            fprintf(file.ID, "\nREDUCE (success metric reduction in each direction): [N, S, W, E] = [%g, %g, %g, %g]",options.REDUCE.N, options.REDUCE.S, options.REDUCE.W, options.REDUCE.E);
        end
        if Change.center
            fprintf(file.ID, "\nNOTE: center value changed manually during first trial.");
            fprintf(file.ID, "\n\tcenter (success metric center box coordinates): [x1, y1; x2, y2] = [%g, %g; %g, %g]",options.center(1,1),options.center(1,2),options.center(2,1),options.center(2,2));
        else
            fprintf(file.ID, "\ncenter (success metric center box coordinates): [x1, y1; x2, y2] = [%g, %g; %g, %g]",options.center(1,1),options.center(1,2),options.center(2,1),options.center(2,2));
        end
        fprintf(file.ID, "\n---------------");
        fprintf(file.ID, "\nChanges During Trials:");
        if  Change.nfft.trials || Change.nfft.frameSize
            fprintf(file.ID, "\nnfft");
        end
        if Change.indxEst
            fprintf(file.ID, "\nindxEst");
        end
        if Change.analysis
            fprintf(file.ID, "\nanalysis");
        end
        if Change.svd
            fprintf(file.ID, "\nsvd");
        end
        if Change.win.w1.m
            fprintf(file.ID, "\nwin.w1.m");
        end
        if Change.win.w2.m
            fprintf(file.ID, "\nwin.w2.m");
        end
    end
    
    save(file.Results,'ContrastMatrix')
        
    fprintf(file.ID, "\n---------------");
    fprintf(file.ID, "\nTRIAL %d:",options.q);
    fprintf(file.ID, "\n\tanalysis (analysis case): %g",options.analysis);
    if Change.nfft.frameSize
        fprintf(file.ID, "\n\tNOTE: FFT analysis size has been changed to equal window length.");
        fprintf(file.ID, "\n\t\tnfft (fft size): %g",win.w1.m);
    else
        fprintf(file.ID, "\n\tnfft (fft size): %g",options.nfft);
    end
    fprintf(file.ID, "\n\tindxEst (index of Estimated Channel): %g",options.indxEst);
    fprintf(file.ID, "\n\tindx (indices of Channel Used to Estimate): %s",num2str(options.indx,' %d'));
    fprintf(file.ID, "\n\tanalysis (analysis case): %g",options.analysis);
    fprintf(file.ID, "\n\tSVD (Singular Value Decomposition on/off): %g",options.svd);
    fprintf(file.ID, "\n\tsv_reduce (Singular Value Reduction Value): %g",options.sv_reduce);
    fprintf(file.ID, "\n\twin.w1.type (Reconstruction Window Type): %s",win.w1.type);
    fprintf(file.ID, "\n\twin.w1.m (Reconstruction Window Length): %g",win.w1.m);
    fprintf(file.ID, "\n\twin.w1.ovr (Reconstruction Window Overlap Factor): %g",win.w1.ovr);
    fprintf(file.ID, "\n\twin.w2.type (Filtering Window Type): %s",win.w2.type);
    if Change.win.w2.m
        fprintf(file.ID,"w2 window length has been changed to equal w1 window length.");
        fprintf(file.ID, "\n\t\twin.w2.m (Filtering Window Length): %g",win.w1.m);
    else
        fprintf(file.ID, "\n\twin.w2.m (Filtering Window Length): %g",win.w2.m);
    end
    fprintf(file.ID, "\n\twin.w2.ovr (Filtering Window Overlap Factor): %g",win.w1.ovr);
    fprintf(file.ID, "\n\twin.w2.beta (Filtering Window Beta): %g",win.w2.beta);       
    fprintf(file.ID, "\n\tweight.type (Least Squares Estimation Weighting Type): %s",options.weight.type);
    fprintf(file.ID, "\n\tweight.TopdB (Weighted Least Squares, dB threshold to keep during estimation): %g",options.weight.TopdB);
    fprintf(file.ID, "\n\tweight.type (Weighted Least Squares, weighting logic for estimation): %s",options.weight.type);

end