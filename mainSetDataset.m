% experimental parameters
meaRate = 20000; %Hz
psth_tBin = 0.05; % s
    
% other parameters
datasetName = "20190510";
experiments = {"20190510"}; %, "20181018b", "20181018a", "20181017", "20180705", "20180209"};
acceptedLabels = 3; % 5=A, 4=AB, 3=ABC

setDataset(datasetName, experiments, acceptedLabels, meaRate, psth_tBin)


