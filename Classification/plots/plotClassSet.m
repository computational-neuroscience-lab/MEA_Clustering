function plotClassSet(typeId)
text = strcat(typeId, ' Cells');
figure('Name', text);
plotSet(classIndices(typeId));


