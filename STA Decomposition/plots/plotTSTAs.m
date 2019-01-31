function plotTSTAs(indices)

load(getDatasetMat(), 'temporalSTAs')
colors = getColors(sum(indices>0));

tSTA = temporalSTAs(indices, :);
tSTA = tSTA - mean(tSTA, 2);
tSTA = tSTA ./ std(tSTA, [], 2);
tSTA = tSTA + mean(tSTA, 2);

stdTrace = std(tSTA, [], 1);
avgSTD = mean(stdTrace);

for i=1:size(tSTA, 1)
    plot(tSTA(i, :), "Color", colors(i, :), "LineWidth", 1.5)
    hold on
end

xlim([1, size(tSTA ,2)]);
ylim([-4, 4]);

if isnan(avgSTD)
    avgSTD_string = "NaN";
else
    avgSTD_string = string(avgSTD);
end

title(strcat("STAs (avgSTD = ", avgSTD_string, ")"))
