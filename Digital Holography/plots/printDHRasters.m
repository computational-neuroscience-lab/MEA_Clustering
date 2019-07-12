exp = '20190510';
cells_cards_folder = ['/home/fran_tr/Projects/MEA_CLUSTERING/Cards/' exp '/DH/cells'];
classes_cards_folder = ['/home/fran_tr/Projects/MEA_CLUSTERING/Cards/' exp '/DH/classes'];

load(getDatasetMat, "cellsTable")
load(getDatasetMat, "classesTable")

% classes = [classesTable.name];
% for class = classes
%     plotExpClassCard(class, exp);
%     filename = regexprep(class, '\.', '_');
%     filepath = strcat(classes_cards_folder, "/", filename);
%     saveas(gcf, filepath,'jpg');
%     close;
% end

cells = 1:numel(cellsTable);
for i_cell = cells
    plotDHRaster(i_cell);
    filename = strcat("dh_cell_", string(i_cell));
    filepath = strcat(cells_cards_folder, "/", filename);
    saveas(gcf, filepath,'jpg');
    close;
end