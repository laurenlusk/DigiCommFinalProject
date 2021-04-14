function plot_Boxes(f_indx,n_indx,MAX_PWR,spectro,H)
    
    figure(H)
    hold on;
    k = 1;
    for i = 1:2:(2*9-1)  
        
        x1 = spectro.rError.f(f_indx(i));
        x2 = spectro.rError.f(f_indx(i+1));
        y1 = spectro.rError.t(n_indx(i));
        y2 = spectro.rError.t(n_indx(i+1));
        z = 1.05*MAX_PWR;
        
        % Rectangle
        plot3([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1],[z z z z z],'r')
           
        % Number
        xx = x1 + (x2 - x1)*0.4;
        yy = y1 + (y2 - y1)*0.5;
        text(xx,yy,z,int2str(k),'Color','red','FontSize',12);
        
        k = k + 1;
    end
    hold off;
end