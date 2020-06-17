experiments = ["STA_TEST"];
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

    main_Offline_STA;
end

