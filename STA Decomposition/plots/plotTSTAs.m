function plotTSTAs(indices, color)

load(getDatasetMat(), 'temporalSTAs')

if exist("color", "var")
    colors = repmat(color, sum(indices>0), 1);
else
    colors = getColors(sum(indices>0));
end

tSTA = temporalSTAs(indices, :);
tSTA = tSTA - mean(tSTA, 2);
tSTA = tSTA ./ std(tSTA, [], 2);
tSTA = tSTA + mean(tSTA, 2);

snr = doSNR(tSTA);

for i=1:size(tSTA, 1)
    plot(tSTA(i, :), "Color", colors(i, :), "LineWidth", 1.5)
    hold on
end

xlim([1, size(tSTA ,2)]);
ylim([-4, 4]);

if isnan(snr)
    avgSTD_string = "NaN";
else
    avgSTD_string = string(snr);
end

title(strcat("STAs (SNR = ", avgSTD_string, ")"))
