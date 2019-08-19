function plotDHPredictions(i_cell)


figure()

try
    ss = get(0,'MonitorPositions'); % try to get the secondary monitor
    x_0 = ss(2, 1);
    y_0 = ss(2, 2);
    width = ss(2, 3);
    height = ss(2, 4);
    set(gcf,'Position',[x_0, y_0, width, height]);
catch
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    set(gcf,'Position',[0, 0, width, height]);
end

subplot(1, 4, 1)
do1DHRaster(i_cell, 1:50)

subplot(1, 4, 2)
do1DHRaster(i_cell, 51:100)

subplot(1, 4, 3);
doDHRaster(i_cell)

subplot(1, 4, 4);
doDHHistogram(i_cell)
