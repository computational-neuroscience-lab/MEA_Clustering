function plotClassCard(typeId, experiments)

if ~exist('experiments', 'var')
    load(getDatasetMat(), 'experiments');
end

indices = classIndices(typeId);
nRows = ceil(numel(experiments) / 3) + 1;

figName = strcat("Class ", typeId);
figure('Name', figName);

subplot(nRows, 4, [1, 2, 3])
plotPSTH(indices);

subplot(nRows, 4, 4)
plotTSTAs(indices);

for iExp = 1:numel(experiments)
    exp_indices = expIndices(experiments{iExp}) & indices;
    
    i_plot = iExp + 3;
    subplot(nRows, 3, i_plot);
    plotSSTAs(exp_indices);
    title(experiments{iExp})
end

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 200 * nRows;
horz = 800;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);