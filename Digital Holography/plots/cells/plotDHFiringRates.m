function plotDHFiringRates(i_cell, session_label, varargin)

% Default Parameters
width_microns_default = 1000;
center_microns_default = 7.5 * 30;
with_labels_default = false;

% Parse Input
p = inputParser;
addRequired(p, 'i_cell');
addRequired(p, 'session_label');
addParameter(p, 'Center_Microns', center_microns_default);
addParameter(p, 'Width_Microns', width_microns_default);
addParameter(p, 'Labels', with_labels_default, @islogical);

parse(p, i_cell, session_label, varargin{:});
width_microns = p.Results.Width_Microns; 
center_microns = p.Results.Center_Microns; 
with_labels = p.Results.Labels; 
   
load(getDatasetMat(), 'cellsTable');
s = load(getDatasetMat(), session_label);
n_session = s.(session_label).sessions(1);

exp_id = char(cellsTable(i_cell).experiment);

sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

H1 = getHomography('dmd', 'img');
H2 = getHomography(['img' num2str(n_session)], 'mea', exp_id);

[sta_2mea, staRef_2mea] = transformImage(H2*H1, sta);
spots_2mea = getDHSpotsCoordsMEA(session_label);

patterns_2_spots = boolean(s.(session_label).stimuli.single);
[n_patterns, n_spots] = size(patterns_2_spots);
spots_by_pattern = zeros(1, n_spots);
for i_p = 1:n_patterns
    spots_by_pattern(i_p) = find(patterns_2_spots(i_p, :));
end

firing_rates_by_patterns = s.(session_label).responses.single.firingRates(i_cell, :);
firing_rates_by_spots = firing_rates_by_patterns(spots_by_pattern);

colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colormap(colorMap);

img_rgb = ind2rgb(sta_2mea, colormap('summer'));
imshow(img_rgb, staRef_2mea);
hold on

scatter(spots_2mea(:,1), spots_2mea(:,2), 60, firing_rates_by_spots, "Filled")
if with_labels 
    text(spots_2mea(:,1) + 1.5, spots_2mea(:,2), string(1:size(spots_2mea, 1)));
end

load(getDatasetMat, "spatialSTAs");
rf = spatialSTAs(i_cell);
rf.Vertices = transformPointsV(H2*H1, rf.Vertices);    
[x, y] = boundary(rf);
plot(x, y, 'k', 'LineWidth', 3);

xlabel('Microns');
ylabel('Microns');

colorMap = [ones(256,1), linspace(1,0,256)' , linspace(1,0,256)'];
colormap(colorMap);
c = colorbar;
c.Label.String = 'Firing Rates (Hz)';

title([session_label ', Cell #' num2str(i_cell) ': RBC activations'], 'Interpreter', 'None')
set(gcf,'Position',[0, 0, 1000, 1000]);
xlim([center_microns-width_microns/2, center_microns+width_microns/2])
ylim([center_microns-width_microns/2, center_microns+width_microns/2])

