function [ws, a, b] = getDHLNPWeights(experiment, i_cell)

dh_lnp_mat = [dataPath '/' char(experiment) '/processed/DH/DHLNP/keras_models.mat'];
load(dh_lnp_mat, 'a', 'b', 'ws');

if exist('i_cell', 'var')
    a = a(i_cell);
    b = b(i_cell);
    ws = ws(i_cell, :);
end