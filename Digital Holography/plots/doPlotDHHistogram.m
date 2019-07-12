function doPlotDHHistogram(i_cell)



% Load PREDICTIONS
figure();

ss = get(0,'screensize');
vert = 2500;
horz = 1500;
set(gcf,'Position',[2000, 1500, horz, vert]);

doDHHistogram(i_cell)