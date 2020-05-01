function plotSSTAs(indices)

load(getDatasetMat(), 'spatialSTAs', 'stas');
rfs = spatialSTAs(indices);

colormap gray

if sum(indices>0)~=1
    colors = getColors(sum(indices>0));
    y_size = size(stas{1}, 1);
    x_size = size(stas{1}, 2);
    background = ones(y_size, x_size)*255;
else
    colors = [1,0,0];
    background = std(stas{indices}, [], 3);
    background = background - min(background(:));
    background = background / max(background(:)) * 255;
    colormap('summer');
end
image(background);

hold on

for i = 1:size(rfs, 2)  
    [x, y] = boundary(rfs(i));
    plot(x, y, 'Color', colors(i, :), 'LineWidth', 1.5)
end

daspect([1 1 1])
axis off

[u_len, v_len] = size(background);
xlim([v_len*.2, v_len*.8])
ylim([u_len*.2, u_len*.8])

title('receptive field')