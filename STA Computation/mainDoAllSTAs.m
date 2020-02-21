experiments = ["20200131_dh"];
sorted = true;


if sorted
    spikes_mat = 'SpikeTimes';
else
    spikes_mat = 'muaSpikeTimes';
end

for experiment = experiments
    exp_id = char(experiment);
    disp(['COMPUTING STA FOR EXPERIMENT ' exp_id])
   
    load([dataPath '/' exp_id '/processed/' spikes_mat '.mat'], 'SpikeTimes');
    n_cells = numel(SpikeTimes);

    triggers_file = [dataPath '/' exp_id '/processed/STA/Frames.mat'];
    spikes_file = [dataPath '/' exp_id '/processed/STA/' spikes_mat '.data'];
    
    main_Offline_STA;
end

