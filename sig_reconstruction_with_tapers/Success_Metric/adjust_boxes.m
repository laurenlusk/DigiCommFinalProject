function [f_indx, n_indx, REDUCE] = adjust_boxes(spectro,center,MAX_PWR,REDUCE,TOL,r,r_est,options,win)
    
    N = length(r_est);

    DONE = 0;
    while (~DONE)
        
        [f_indx, n_indx] = calc_locations(center, REDUCE, TOL, spectro,win,N);
        
        create_spectro(r, r_est, options);
        H = gcf;
        plot_Boxes(f_indx, n_indx, MAX_PWR, spectro, H);
         
        tmp = "W";
        while(~strcmp(tmp,"Y")&&~strcmp(tmp,"N")||isempty(tmp))
             tmp = input("Would you like to adjust the surrounding rectangles? (Y/N): ",'s');
             tmp = upper(tmp);
        end

        if (strcmp(tmp,"N")||isempty(tmp))
        	DONE = 1; % Defaults to no adjustment
        else
        	fprintf('\nCurrent Reduction Value for [N, S, W, E] = [%f, %f, %f, %f]\n',...
                     REDUCE.N, REDUCE.S, REDUCE.W, REDUCE.E);
            fprintf('Please choose reduce box diagonals.\n');
            [x,y] = ginput(2);
                 
            % Height in points of center rectangle
            H_center = n_indx(2) - n_indx(1);
            % Width in points of center rectangle
            W_center = f_indx(2) - f_indx(1);
            
            [~, minY_Indx] = min(abs(spectro.rError.t - min(y)));
            [~, maxY_Indx] = min(abs(spectro.rError.t - max(y))); 
            [~, minX_Indx] = min(abs(spectro.rError.f - min(x)));
            [~, maxX_Indx] = min(abs(spectro.rError.f - max(x))); 
            
            REDUCE.N = (maxY_Indx - n_indx(3))./H_center;
            REDUCE.S = (n_indx(10)- minY_Indx)./H_center;
            REDUCE.W = (f_indx(16) - minX_Indx)./W_center;
            REDUCE.E = (maxX_Indx - f_indx(7))./W_center;
            
            close(H)
        end
    end
        
end