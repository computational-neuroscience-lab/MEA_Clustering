close all
clear
clc

% changeDataset("RGC");
% % main_findDuplicates;
% main_mosaicsStats;
% main_mosaicsSignificance;
% 
% changeDataset("CNN");
% main_findDuplicates;
% main_mosaicsStats;
% main_mosaicsSignificance;

[matchTable, matchByCellsTable, matchGrid] = compare_partitions_all("RGC", "CNN");
save("_data/RGC_Matching.mat", "matchTable", "matchByCellsTable", "matchGrid")

[matchTable, matchByCellsTable, matchGrid] = compare_partitions_all("CNN", "RGC");
save("_data/CNN_Matching.mat", "matchTable", "matchByCellsTable", "matchGrid")

