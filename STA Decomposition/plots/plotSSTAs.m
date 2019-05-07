function plotSSTAs(indices)

load(getDatasetMat(), 'spatialSTAs', 'stas');
colors = getColors(sum(indices>0));

sSTAs = spatialSTAs(indices);

colormap gray
y_size = size(stas{1}, 1);
x_size = size(stas{1}, 2);
background = ones(y_size, x_size) * 255;
image(background);
hold on

for i =1:size(sSTAs, 2)  
    plot(sSTAs(i).x, sSTAs(i).y, 'Color', colors(i, :), 'LineWidth', 1.5)
end

xlim([(x_size*.3), (x_size*.7)])
ylim([(y_size*.3), (y_size*.7)])
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);