function accuracy = getDHLNPAccuracies(experiment, i_cell)
dh_lnp_mat = [dataPath '/' char(experiment) '/processed/DH/DHLNP/keras_models.mat'];
load(dh_lnp_mat, 'accuracy');

if exist('i_cell', 'var')
    accuracy = accuracy(i_cell);
end
