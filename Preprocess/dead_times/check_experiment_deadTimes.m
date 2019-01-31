function check_experiment_deadTimes(expId)

sorted_exp_path = strcat(dataPath, '/', expId, '/sorted/');
spikesFile = strcat(sorted_exp_path, 'CONVERTED/CONVERTED.result.hdf5');
deadTimesFile = strcat(sorted_exp_path, 'dead_times.txt');

spike_times = extractSpikeTimes(spikesFile);
dead_times = load(deadTimesFile); 
check_deadTimes(dead_times, spike_times);