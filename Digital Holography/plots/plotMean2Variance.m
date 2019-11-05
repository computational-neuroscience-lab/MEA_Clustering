function plotMean2Variance(i_cell)
load(getDatasetMat, "dh")

mean_ps = [];
var_ps = [];
for i_pattern = 1:size(dh.responses.test.spikeCounts, 2)
    responses_repeated = dh.responses.test.spikeCounts{i_cell,i_pattern};
    mean_p = mean(responses_repeated);
    var_p = var(responses_repeated);
    
    mean_ps = [mean_ps mean_p];
    var_ps = [var_ps var_p];
end

for i_pattern = 1:size(dh.responses.singles.spikeCounts, 2)
    responses_single = dh.responses.singles.spikeCounts{i_cell, i_pattern};
    mean_p = mean(responses_single);
    var_p = var(responses_single);
    
    mean_ps = [mean_ps mean_p];
    var_ps = [var_ps var_p];
end

scatter(mean_ps, var_ps, 30, "Filled")
hold on

edge = max([mean_ps, var_ps]);
plot([0,edge], [0,edge])
xlim([0, edge]);
ylim([0, edge]);
title(strcat("Cell#", string(i_cell), ": spiking-rate statistics"));
xlabel("Spiking-Rate Mean (Hz)")
ylabel("Spiking-Rate Variance")
