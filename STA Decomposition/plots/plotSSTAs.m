function plotSSTAs(indices)

load(getDatasetMat(), 'spatialSTAs', 'stas');

colormap gray
background = ones(size(stas{1}, 1), size(stas{1}, 2)) * 255;
image(background);
hold on

for i = find(indices)
    plot(spatialSTAs(i).x, spatialSTAs(i).y)
end
title("Spatial STAs")