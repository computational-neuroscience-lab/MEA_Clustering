clear

% Params
changeDataset('20200131_dh')
exp_id = '20200131_dh';
dh_labels_to_process = "DHMulti";
pattern_labels = ["single", "test", "multi"];
dead_electrodes = [];
stim_electrodes = [127 128 255 256];

mea_rate = 20000;   % HzM
stim_duration = 0.5*mea_rate;
time_spacing = 0.2*mea_rate;

% Folders
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];
residuals_folder = [dataPath(), '/', exp_id, '/processed/DH/'];

% Load
load(mea_file, 'Positions')
mea_map = double(Positions);

tot_residuals = -inf;
for dh_label = dh_labels_to_process
    points = getDHSpotsCoordsMEA(dh_label);
    s = load(getDatasetMat, dh_label);

    for p_label = pattern_labels
        residual_file = [char(dh_label) '_' char(p_label) '_residuals.mat'];
        load([residuals_folder '/' residual_file], 'dead_init', 'dead_end', 'mea_residual', 'elec_residuals', 'time_spacing', 'stim_duration', 'mea_rate')        
            
        for i_patterns = 1:numel(elec_residuals)
            pattern = logical(s.(dh_label).stimuli.(p_label)(i_patterns, :));
            tot_residuals = max(elec_residuals{i_patterns}, tot_residuals);
            
            % Plot Artifact Residual
%             plotMEA()
%             plotDataMEA(elec_residuals{i_patterns}, mea_map, 'blue', dead_electrodes)
%             title(residual_file, 'Interpreter', 'None')
%             scatter(points(pattern,1), points(pattern,2), 50, 'r', 'filled')
%             
%             % Get Dead Interval around artifact Residuals
%             plotDeadIntervals(dead_init{i_patterns}, dead_end{i_patterns}, mea_residual{i_patterns}, time_spacing, stim_duration, mea_rate);
%             title(residual_file, 'Interpreter', 'None')
%             waitforbuttonpress();
%             close all
        end
    end
end


plotMEA()
plotDataMEA(tot_residuals, mea_map, 'blue', dead_electrodes)
title('Total Residual', 'Interpreter', 'None')

residual = computeMEAResidual([dead_electrodes, stim_electrodes], tot_residuals);
[dead_init, dead_end] = computeDeadIntervals(residual, time_spacing);

% Get Dead Interval around artifact Residuals
mea_rate = 20000;   % HzM
plotDeadIntervals(dead_init, dead_end, residual, time_spacing, stim_duration, mea_rate);