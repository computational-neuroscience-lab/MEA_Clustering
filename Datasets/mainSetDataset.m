% experimental parameters
meaRate = 20000; %Hz
psth_tBin = 1/30; % s
    
% other parameters
datasetName = "20200109_a2new";
experiments = {"20200109_a2"}; %, "20181018b", "20181018a", "20181017", "20180705", "20180209"};
acceptedLabels = 3; % 5=A, 4=AB, 3=ABC

% setDataset(datasetName, experiments, acceptedLabels, meaRate, psth_tBin)
setDataset(datasetName, experiments, acceptedLabels, meaRate, psth_tBin)


