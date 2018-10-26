function [tSta, tSta_in, tSta_out] = extractTemporalSta(sta, xEll, yEll)

% Extract tempor
tSta_in = [];
tSta_out = [];

[dim_x, dim_y, dim_t] = size(sta);
for xi = 1:dim_x
    for yi = 1:dim_y
        if inpolygon(xi, yi, yEll, xEll)
            tSta_in = [tSta_in, squeeze(sta(xi, yi, :))];
        else
            tSta_out = [tSta_out, squeeze(sta(xi, yi, :))];
        end
    end
end

tSta = mean(tSta_in, 2);
