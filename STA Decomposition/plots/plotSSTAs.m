function plotSSTAs(indices)

load(getDatasetMat(), 'spatialSTAs', 'stas');

colormap gray
y_size = size(stas{1}, 1);
x_size = size(stas{1}, 2);
background = ones(y_size, x_size) * 255;
image(background);
hold on

for i = find(indices)
    plot(spatialSTAs(i).x, spatialSTAs(i).y)
end

xlim([(x_size*.3), (x_size*.7)])
ylim([(y_size*.3), (y_size*.7)])
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);