function plotTSTAs(indices)

load(getDatasetMat(), 'temporalSTAs')

tSTA = temporalSTAs(indices, :);
tSTA = tSTA - mean(tSTA, 2);
tSTA = tSTA ./ std(tSTA, [], 2);
tSTA = tSTA + mean(tSTA, 2);

stdTrace = std(tSTA, [], 1);
avgSTD = mean(stdTrace);

plot(tSTA.')
xlim([1, size(tSTA ,2)]);
ylim([-4, 4]);

if isnan(avgSTD)
    avgSTD_string = "NaN";
else
    avgSTD_string = string(avgSTD);
end
title(strcat("STAs (avgSTD = ", avgSTD_string, ")"))