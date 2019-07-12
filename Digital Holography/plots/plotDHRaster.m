function plotDHRaster(i_cell)

load(getDatasetMat, "dh_stats")

figure()
title_1 = strcat("Cell #", string(i_cell));
title_2 = strcat("LNP accuracy = ",  string(dh_stats.accuracies(i_cell)));
title_3 = strcat("Activation Index = ",  string(dh_stats.activation(i_cell)));
title_4 = strcat("Adaptation Index = ",  string(dh_stats.adaptation_abs(i_cell)));

ss = get(0,'screensize');
vert = 2500;
horz = 1500;
set(gcf,'Position',[2000, 1500, horz, vert]);

suptitle({title_1, title_2, title_3, title_4})
subplot(1,2,1)
doDHRaster(i_cell, "singles")
title("Raster Single Spots")
subplot(1,2,2)
doDHRaster(i_cell, "repeated")
title("Raster Repeated Patterns")


