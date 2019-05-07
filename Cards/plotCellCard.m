function plotCellCard(indices)
loadDataset()
experiment = unique([cellsTable(indices).experiment]);
if numel(experiment) > 1
    error("cannot compare cells from different experiments");
end

load(getDatasetMat(), 'psths', 'params')
tBin = params.psth.tBin;

figName = strcat("Figure");
figure('Name', figName);

subplot(2, 5, [1, 2, 3, 4])
plotPSTH(indices);

subplot(2, 5, [6, 7])
plotTSTAs(indices);

subplot(2, 5, [8, 9]);
plotSSTAs(indices);
title("Receptive Fields", "Interpreter", "none");

subplot(2, 5, [5, 10]);
title(strcat("Exp #", experiment), "Interpreter", "none");
text(.2, .95, "INDICES:")

n_indices = sum(indices>0);
indices = [cellsTable(indices).N];
colors = getColors(n_indices);
for i = 1:n_indices
    text(.2, .9 - (.9 / n_indices * i), string(indices(i)), "Color", colors(i, :))
end
grid off
axis off

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 750;
horz = 1000;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);