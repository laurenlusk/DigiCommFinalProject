function plot_coeff(c, options)
    % Plotting Estimation Coefficients (both mag and phase)
    % c: estimation coefficients
    % options: struct containing user defined parameters for estimation

    indx = 1:8;
    y = length(indx); % number of channels used to estimate
    
    % Plotting Coefficients
    figure()
    ax(1) = subplot(2,1,1);
        for j = 1:y
            plot(abs(c(:,j,1)))
            hold on
        end
        xlabel("\bf{Window Frame Index}")
        ylabel("\bf{|LLC|}")
        tmp = num2str(indx.', 'Channel %-d');
        legend(cellstr(tmp))
        title(sprintf("Magnitude of Linear Combination Coefficients")
        hold off
    
    ax(2) = subplot(2,1,2);
        for j = 1:y
            plot(angle(c(:,j,1)))
            hold on
        end
        xlabel("\bf{Window Frame Index}")
        ylabel("\bf{\angle LLC}",'Interpreter','latex') 
        legend(cellstr(tmp))
        title("Phase of Linear Combination Coefficients")
        hold off  
       
    linkaxes(ax,'x')    
end