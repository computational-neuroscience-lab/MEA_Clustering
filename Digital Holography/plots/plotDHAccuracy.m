function plotDHAccuracy(i_cell, model)


load(getDatasetMat(), "dh_models");
prediction = dh_models.(model).predictions(i_cell, :)';
firingRates = dh_models.(model).firingRates(i_cell, :)';

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

scatter(firingRates, prediction, 100, 'Filled', 'o')
ylabel("Predicted Firing-Rates (Hz)");
xlabel("True Firing-Rates (Hz)");

hold on
plot_edge = max([firingRates; prediction]);
plot([0,plot_edge], [0,plot_edge], "LineWidth", 3, "Color", [.2, .2, .2])
xlim([0, plot_edge]);
ylim([0, plot_edge]);
pbaspect([1 1 1])

title1 = "Predicted Mean Firing-Rate Across DH Patterns";
title2 = strcat("Cell #", string(i_cell), ": accuracy = ", string(dh_models.(model).accuracies(i_cell)));
title({title1; title2});
