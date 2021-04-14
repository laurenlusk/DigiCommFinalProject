function plot_box(x1,x2,y1,y2,MAX_PWR, H)

    z = 1.05*MAX_PWR;
    figure(H)
    hold on
    plot3([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1],[z z z z z],'r')
    hold off

end