function avgSTD = plotMeanTrace(logicalIndices)

load(getDatasetMat, 'tracesMat');

traces = tracesMat(logicalIndices, :);
avgTrace = mean(traces, 1);
stdTrace = std(traces, [], 1);
upSTD = avgTrace + stdTrace / 2;
downSTD = avgTrace - stdTrace / 2;
avgSTD = mean(stdTrace);

% Plot Standard Deviation
x = 1:length(avgTrace);
x2 = [x, fliplr(x)];
inBetween = [upSTD, fliplr(downSTD)];
fill(x2, inBetween, [0.75, 0.75, 0.75]);
 hold on
 
% Plot Mean
plot(avgTrace, 'r', 'LineWidth', 3)
xlim([0, size(avgTrace, 2)]);

xticks([0, 150, 300, 450, 600]);
xticklabels([0, 150, 300, 450, 600] / 30);
xlabel('(s)')

if isnan(avgSTD)
    avgSTD_string = "NaN";
else
    avgSTD_string = string(avgSTD);
end

title(strcat("Mean Trace (avgSTD = ", avgSTD_string, ")"))
