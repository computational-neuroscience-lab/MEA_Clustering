function plotMean2Variance(i_cell)
load(getDatasetMat, "dh")

mean_ps = [];
var_ps = [];
for i_pattern = 1:50
    responses_repeated = dh.responses.repeated.responses{i_cell,i_pattern};
    mean_p = mean(mean(responses_repeated, 3), 2);
    var_p = var(mean(responses_repeated, 3), 0, 2);
    
    mean_ps = [mean_ps mean_p];
    var_ps = [var_ps var_p];
end

for i_pattern = 1:100
    responses_single = dh.responses.singles.responses{i_cell, i_pattern};
    
    mean_p = mean(mean(responses_single, 3), 2);
    var_p = var(mean(responses_single, 3), 0, 2);
    
    mean_ps = [mean_ps mean_p];
    var_ps = [var_ps var_p];
end

figure
scatter(mean_ps, var_ps, 30, "Filled")
hold on
plot([0,50], [0,50])
xlim([0, 50]);
ylim([0, 50]);
title(strcat("Cell#", string(i_cell), ": spiking rate statistics"));
xlabel("mean")
ylabel("variance")