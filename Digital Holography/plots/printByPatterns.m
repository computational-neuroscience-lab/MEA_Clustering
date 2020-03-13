for i = 1:36
    plotDHRaster_by_pattern(i, 'DHSingle', 'single')
    saveas(gcf, [tmpPath '/DHSingle_raster_pattern'  num2str(i_cell)], 'jpg');
    close;
end