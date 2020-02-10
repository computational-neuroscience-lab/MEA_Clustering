clear

% Params
exp_id = '20200131_dh';

dh_labels_to_process = ["DHMulti"];
dh_sessions_to_mask = [];

dead_electrodes = [];
stim_electrodes = [127 128 255 256];

mea_rate = 20000;   % HzM
stim_duration = 0.5*mea_rate;
time_spacing = 0.2*mea_rate;
encoding = 'uint16';

% Inputs
dh_times_file = [dataPath() '/' exp_id '/processed/DH/DHTimes.mat'];
raw_file = [dataPath(), '/', exp_id, '/sorted/CONVERTED.raw'];
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];

% Outputs
residuals_file = 'dh_residuals.mat';
residuals_folder = [dataPath(), '/', exp_id, '/processed/DH'];
dead_times_file = [dataPath(), '/', exp_id, '/sorted/dead_times.txt'];

% Load
load(dh_times_file, 'dhTimes')
load(mea_file, 'Positions')
mea_map = double(Positions);

% Try to load the residuals if they exist
try
    load([residuals_folder '/' residuals_file], 'stim_residuals', 'stim_duration', 'time_spacing');
end
    
% Make sure the old parameters are the same
stim_duration_tmp = stim_duration;
time_spacing_tmp = time_spacing;
if (stim_duration_tmp ~= stim_duration) || (time_spacing_tmp ~= time_spacing) 
    error(' you are mixing residual artifacts computed with different parameters')
end

if ~exist('stim_residuals', 'var')
    stim_residuals = struct();
end

% Compute Artifact Residuals
for dh_label = dh_labels_to_process
    
    % for each dh_session compute the residuals if they do not exist yet
    if ~isfield(stim_residuals, dh_label)
        s = load(getDatasetMat, dh_label);
        
        pattern_labels = fieldnames(s.(dh_label).repetitions);
        for i_p = 1:numel(pattern_labels)
            p_label = pattern_labels{i_p};
            stim_triggers = s.(dh_label).repetitions.(p_label);
            fprintf('%s patterns:\n', p_label);
            
            elec_residuals = computeElecStimResidual(raw_file, stim_triggers, stim_duration, time_spacing, mea_map, encoding);
            [mea_residual, dead_init, dead_end] = computeMEAStimResidual([stim_electrodes, dead_electrodes], elec_residuals, time_spacing);

            stim_residuals.(dh_label).(p_label).elec_residuals = elec_residuals;
            stim_residuals.(dh_label).(p_label).mea_residual = mea_residual;
            stim_residuals.(dh_label).(p_label).dead_init = dead_init;
            stim_residuals.(dh_label).(p_label).dead_end = dead_end;
            
%             for i_patterns = 1:numel(elec_residuals)
%                 % Plot Artifact Residual
%                 plotMEA()
%                 plotDataMEA(elec_residuals{i_patterns}/10, mea_map, 'blue', dead_electrodes)
% 
%                 % Get Dead Interval around artifact Residuals
%                 plotDeadIntervals(dead_init{i_patterns}, dead_end{i_patterns}, mea_residual{i_patterns}, time_spacing, stim_duration, mea_rate);
%                 waitforbuttonpress();
%                 close all
%             end
        end
    end
end

save([tmpPath '/' 'dh_residuals.mat'], 'stim_residuals', 'stim_duration', 'time_spacing');
movefile([tmpPath '/' 'dh_residuals.mat'], residuals_folder);


% Put all dead times together
dead_times_artifacts = [];

dh_sessions = fields(stim_residuals);
for i_dh = 1:numel(dh_sessions)
    dh_session = dh_sessions{i_dh};
    dh_struct = load(getDatasetMat, dh_session);

    
    dh_types = fields(stim_residuals.(dh_session));
    for i_type = 1:numel(dh_types)
        dh_type = dh_types{i_type};
            for i_patt = 1:numel(stim_residuals.(dh_session).(dh_type).dead_init)
                di = stim_residuals.(dh_session).(dh_type).dead_init{i_patt};
                de = stim_residuals.(dh_session).(dh_type).dead_end{i_patt};
                triggs = dh_struct.(dh_session).repetitions.(dh_type){i_patt};

                dead_times_artifacts = [dead_times_artifacts; computeDeadTimes(triggs, di, de)];
            end
    end
end

% Compute Dead Times on dh session to mask completely:
dead_times_covered = zeros(numel(dh_sessions_to_mask), 2);
for i_dh = dh_sessions_to_mask
    dead_init = dhTimes{i_dh}.evtTimes_begin(1) - time_spacing;
    dead_end = dhTimes{i_dh}.evtTimes_end(end) + time_spacing;
    dead_times_covered(i_dh, :) =  [dead_init dead_end];
end

% Put together and sort all dead times
dead_times = [dead_times_artifacts; dead_times_covered];
[~, order] = sort(dead_times(:,1));
dead_times = dead_times(order, :);

writematrix(dead_times, dead_times_file, 'Delimiter', 'tab')