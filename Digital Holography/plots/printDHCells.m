cells_cards_folder = "/home/fran_tr/Projects/MEA_CLUSTERING/Analysis_MEA/Digital Holography/_data/cards/cells";
classes_cards_folder = "/home/fran_tr/Projects/MEA_CLUSTERING/Analysis_MEA/Digital Holography/_data/cards/classes";
exp = "20170614";

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

cells = 56:numel(cellsTable);
for i_cell = cells
    plotDHCell(i_cell);
    filename = strcat("dh_cell_", string(i_cell));
    filepath = strcat(cells_cards_folder, "/", filename);
    saveas(gcf, filepath,'jpg');
    close;
end