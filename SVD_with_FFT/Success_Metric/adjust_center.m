function [center] = adjust_center(spectro,r,options,MAX_PWR)
    
    center = options.center;

    DONE = 0;
    while (~DONE)
        create_spectro(r,options);
        H = gcf;
        
        [center] = obtain_center(center, spectro);
        
    	x1 = spectro.rError.f(center(1,1));
        x2 = spectro.rError.f(center(2,1));
        y1 = spectro.rError.t(center(1,2));
        y2 = spectro.rError.t(center(2,2));
        
        plot_box(x1,x2,y1,y2,MAX_PWR,H);
        
        tmp = "W";
        while(~strcmp(tmp,"Y")&&~strcmp(tmp,"N")||isempty(tmp))
            tmp = input("Would you like to adjust the location of the center box? (Y/N): ",'s');
            tmp = upper(tmp);
        end
        
        if (strcmp(tmp,"N")||isempty(tmp))
            DONE = 1; % Defaults to no adjustment
        else
            center = [];
        end
        save(strcat(fullfile(pwd,'sig_reconstruction_with_tapers','contrast_matrix'),'\center.mat'),'center')
        close(H)
    end

end
