function snr = plotPSTH(indices, colors)

load(getDatasetMat(), 'psths', 'params', 'cellsTable')
tBin = params.psth.tBin;

traces = psths(indices, :);
traces = traces ./ max(traces, [], 2);
avgTrace = mean(traces, 1);
stdTrace = std(traces, [], 1);
upSTD = avgTrace + stdTrace / 2;
downSTD = avgTrace - stdTrace / 2;
snr = doSNR(traces);

stim_mat = [stimPath() '/Euler/Euler_Stim.mat'];
load(stim_mat, 'euler', 'euler_sampler_rate');

x_stim = cumsum(ones(1, length(euler)) / euler_sampler_rate);
plot(x_stim, euler/max(euler), 'k')
hold on

% Plot Standard Deviation
xs = cumsum(ones(1, length(avgTrace)) * tBin);
x2 = [xs, fliplr(xs)];
inBetween = [upSTD, fliplr(downSTD)];
fill(x2, inBetween, [0.75, 0.75, 0.75]);
 
% Plot Mean
if exist("colors", "var")
    plot(xs, avgTrace, 'LineWidth', 3, 'Color', colors)
else
    plot(xs, avgTrace, 'r', 'LineWidth', 3)
end
xlim([0, xs(end)]);
ylim([-0.1, +1.1]);
xlabel('Time (s)')
ylabel('Normalized Firing-Rate')

if isnan(snr)
    snr_string = "NaN";
else
    snr_string = string(snr);
end

title(strcat("Mean Euler PSTH (SNR = ", snr_string, ")"))
