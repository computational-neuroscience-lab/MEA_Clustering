function [ws_norm, a, b] = getDHLNPWeights(i_cell)

load(getDatasetMat, 'dh_models');
ws = dh_models.ws;
b = dh_models.b;

a = max(abs(ws), [], 2);
ws_norm = ws ./ repmat(a, 1, size(ws,2));

if exist('i_cell', 'var')
    a = a(i_cell);
    b = b(i_cell);
    ws_norm = ws_norm(i_cell, :);
end