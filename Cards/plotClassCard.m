function isValid = plotClassCard(typeId, expId)

if exist('expId', 'var')
    indices = expIndices(expId) & classIndices(typeId);
    figName = strcat("Class ", typeId, " [experiment ", string(expId), "]");
else
    indices = classIndices(typeId);
    figName = strcat("Class ", typeId);
end

isValid = sum(indices) > 0;
if isValid
    figure('Name', figName);
    subplot(4,1,1)
    avgSTD = plotPSTH(indices);

    subplot(4,1,2)
    plotTSTAs(indices)

    subplot(4,1,[3,4])
    plotSSTAs(indices)

    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 900;
    horz = 600;
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
    suptitle(typeId)
end

