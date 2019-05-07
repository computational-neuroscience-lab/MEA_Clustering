% experimental parameters
meaRate = 20000; %Hz
psth_tBin = 0.05; % s
    
% other parameters
datasetName = "aaa";
experiments = {"20170614"};
acceptedLabels = 3; % 5=A, 4=AB, 3=ABC

setDataset(datasetName, experiments, acceptedLabels, meaRate, psth_tBin)


