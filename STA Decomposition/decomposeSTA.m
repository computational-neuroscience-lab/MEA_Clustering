function [temporal, spatial, rfs, indices] = decomposeSTA(stas, doSmoothing)

if ~exist('doSmoothing', 'var')
    doSmoothing = false;
end

[n_rows, n_cols, n_steps] = size(stas{1});
n_cells = numel(stas);

temporal = zeros(n_cells, n_steps);
spatial = zeros(n_cells, n_rows, n_cols);
rfs(n_cells) = polyshape();
is_good_sta = false(n_cells, 1);


for i=1:length(stas)
    sta = stas{i};
    
    if sum(sta(:)) ~= 0
        
        % filter the sta to remove some noise
        if doSmoothing
            spatial_sta = std(smoothSta(sta), [], 3);
        else
            spatial_sta = std(sta, [], 3);
        end
        spatial(i, :, :) = spatial_sta;
%         imagesc(spatial_sta);
%         waitforbuttonpress();
        
        % Fit The ellipses
        [xEll, yEll, ~, ~] =  fitEllipse(spatial_sta);
        [is_valid, ~] = validateEllipse(xEll, yEll, spatial_sta);
        
        
        if is_valid
            is_good_sta(i) = true;
            temporal(i, :) = extractTemporalSta(sta, xEll, yEll);
            rfs(i) = polyshape(xEll, yEll);
        end
    end
end
indices = find(is_good_sta);







