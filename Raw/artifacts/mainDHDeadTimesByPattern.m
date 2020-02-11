clear

% Params
exp_id = '20200131_dh';
dh_labels_to_process = ["DHMulti"];
pattern_labels = ["single", "test", "multi"];

dh_sessions_to_mask = [2 3 4];
mea_rate = 20000;   % Hz
time_spacing = 0.2*mea_rate;

% Inputs
residuals_folder = [dataPath(), '/', exp_id, '/processed/DH/'];
dh_times_file = [dataPath() '/' exp_id '/processed/DH/DHTimes.mat'];
load(dh_times_file, 'dhTimes')

% Outputs
dead_times_file = [dataPath(), '/', exp_id, '/sorted/dead_times.txt'];


% Put all dead times together
dead_times_artifacts = [];

for dh_label = dh_labels_to_process
    s = load(getDatasetMat, dh_label);
    
    for p_label = pattern_labels
        residual_file = [char(dh_label) '_' char(p_label) '_residuals.mat'];
        load([residuals_folder '/' residual_file], 'dead_init', 'dead_end');
        stim_triggers = s.(dh_label).repetitions.(p_label);

        for i_patt = 1:numel(dead_init)
            di = dead_init{i_patt};
            de = dead_end{i_patt};
            trigs = stim_triggers{i_patt};
            dead_times_artifacts = [dead_times_artifacts; computeDeadTimes(trigs, di, de)];
        end
    end
end

% Compute Dead Times on dh session to mask completely:
dead_times_covered = zeros(numel(dh_sessions_to_mask), 2);
for i_dh = 1:numel(dh_sessions_to_mask)
    dh_session = dh_sessions_to_mask(i_dh);
    dead_init = dhTimes{dh_session}.evtTimes_begin(1) - time_spacing;
    dead_end = dhTimes{dh_session}.evtTimes_end(end) + time_spacing;
    dead_times_covered(i_dh, :) =  [dead_init dead_end];
end

% Put together and sort all dead times
dead_times = [dead_times_artifacts; dead_times_covered];
[~, order] = sort(dead_times(:,1));
dead_times = dead_times(order, :);

writematrix(dead_times, dead_times_file, 'Delimiter', 'tab')