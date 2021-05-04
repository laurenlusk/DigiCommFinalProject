function plot_contrast_matrix(ContrastMatrix,options)

%define your custom color order
ColorCustom_1 = [0 0 1;...
                 220/255 20/255, 60/255;...
                 0.4660, 0.6740, 0.1880;...
                 0.75, 0, 0.75;...
                 0.8500, 0.3250, 0.0980;...
                 0, 0.75, 0.75];
           
ColorCustom_2 = [255/255 145/255 0/255;...
                 170/255 40/255 222/255;...
                 47/255 209/255 29/255];
           
Marker = ['--o';'--x';'--s'];         

%%%%%%%%%%%%%%%%%%%%%%%
[x, y, z] = size(ContrastMatrix);

AVG = zeros(8,x);
MED = zeros(8,x);
MID = zeros(8,x);
minContrast = zeros(x,3); 
minBox = zeros(x,3); 
weightedCon = zeros(x,3); 

for i = 1:x
    CM = reshape(ContrastMatrix(i,:,:),[8 3]);
    AVG(:,i) = db(CM(:,1),'power');
    MED(:,i) = db(CM(:,2),'power');
    MID(:,i) = db(CM(:,3),'power');
    
    txt = options.legendLabels;

    for j = 1:3
        [minContrast(i,j), minBox(i,j)] = min(db(CM(:,j),'power'));
        tmp = sum(options.success.cardinal*CM([1 3 5 7],j)) + ...
              sum(options.success.diagonals*CM([2 4 6 8],j));
        weightedCon(i,j) = db(tmp./(4*options.success.cardinal + 4*options.success.diagonals),'power');
    end
end

figure()
set(gca, 'ColorOrder', ColorCustom_1, 'NextPlot', 'replacechildren');
for i = 1:x
    if mod(i,3) == 0
        plot(2:9,MED(:,i),Marker(3,:),'MarkerSize',7,'LineWidth',2)
    else
        plot(2:9,MED(:,i),Marker(mod(i,3),:),'MarkerSize',7,'LineWidth',2)
    end
    hold on
end
hold off
legend(cellstr(txt.'))
xlabel("Boxes") 
ylabel("Contrast Ratio (dB)")
options.offset = options.offset + 1;
end