function plotTSTAs(indices)

load(getDatasetMat(), 'temporalSTAs')
plot(temporalSTAs(indices, :).')
xlim([1, size(temporalSTAs ,2)]);
title(strcat("Temporal STAs (size class = ", string(sum(indices)), ")"))