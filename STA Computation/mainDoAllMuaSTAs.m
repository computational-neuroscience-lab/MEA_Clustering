experiments = ["20191011_grid"];

for experiment = experiments
    disp(strcat("COMPUTING STA FOR EXPERIMENT ", experiment))
    
    exp_Id = char(experiment);
    load([dataPath '/' exp_Id '/processed/muaSpikeTimes.mat'], 'SpikeTimes');
    
    triggers_file = [dataPath '/' exp_Id '/processed/STA/Frames.mat'];
    spikes_file = [dataPath '/' exp_Id '/processed/STA/muaSpikeTimes.data'];
    n_cells = numel(SpikeTimes);
    
    
    main_Offline_STA;
end

