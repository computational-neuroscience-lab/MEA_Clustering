function avgSTD = plotPSTH(indices)

load(getDatasetMat(), 'psths', 'params')
tBin = params.tBin;

traces = psths(indices, :);
traces = traces ./ max(traces, [], 2);
avgTrace = mean(traces, 1);
stdTrace = std(traces, [], 1);
upSTD = avgTrace + stdTrace / 2;
downSTD = avgTrace - stdTrace / 2;
avgSTD = mean(stdTrace);

% Plot Standard Deviation
xs = cumsum(ones(1, length(avgTrace)) * tBin);
x2 = [xs, fliplr(xs)];
inBetween = [upSTD, fliplr(downSTD)];
fill(x2, inBetween, [0.75, 0.75, 0.75]);
 hold on
 
% Plot Mean
plot(xs, avgTrace, 'r', 'LineWidth', 3)
xlim([0, xs(end)]);

xlabel('(s)')

if isnan(avgSTD)
    avgSTD_string = "NaN";
else
    avgSTD_string = string(avgSTD);
end

title(strcat("Mean Trace (avgSTD = ", avgSTD_string, ")"))
