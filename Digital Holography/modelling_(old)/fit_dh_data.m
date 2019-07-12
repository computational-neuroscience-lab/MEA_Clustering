clear
close all

% Data Paths
data_path = "_data/";
dh_mat = strcat(data_path, "dh_train_set.mat");

% load the datasets
load(dh_mat, "x_unique", "y_unique","x_repeated", "y_repeated");
x_train = x_unique;
y_train = y_unique;
x_val = x_repeated;
y_val = y_repeated;

n_in = size(x_train, 1);
n_cells = size(y_train, 1);
n_out = 1;

% iterate over good cells (selected manually by looking at DH_PSTHs)
selected_cell_indices = [6, 10, 20, 24, 30, 36, 38, 41, 46, 51, 57, 60, 64, 82];

y_train_selected_cells = y_train(selected_cell_indices, :);
y_val_selected_cells = y_val(selected_cell_indices, :);

parfor i = 1:length(selected_cell_indices)
    
    i_cell = selected_cell_indices(i);
    y_train_cell = y_train_selected_cells(i, :);
    y_val_cell = y_val_selected_cells(i, :);

    % create the ANNs
    perceptron = ANN([n_in, n_out]);
    ln_model = ANN([n_in, 1, 10, n_out]);
    ann_model = ANN([n_in, n_in, n_out]);

    perceptron.tune_to_dataset_statistics(x_train, y_train_cell)
    ln_model.tune_to_dataset_statistics(x_train, y_train_cell)
    ann_model.tune_to_dataset_statistics(x_train, y_train_cell)

    % train it
    fprintf("training perceptron of cell #%i...\n", i_cell);
    [perc_training_err, perc_val_err] = perceptron.train(x_train, y_train_cell, x_val, y_val_cell);
    fprintf("training LN model of cell #%i...\n", i_cell);
    [ln_training_err, ln_val_err] = ln_model.train(x_train, y_train_cell, x_val, y_val_cell);
    fprintf("training ANN model of cell #%i...\n", i_cell);
    [ann_training_err, ann_val_err] = ann_model.train(x_train, y_train_cell, x_val, y_val_cell);

    % save it
    fprintf("saving models of cell #%i...\n", i_cell);
    save_model(i_cell, "perc", perceptron, perc_training_err, perc_val_err); 
    save_model(i_cell, "ln", ln_model, ln_training_err, ln_val_err); 
    save_model(i_cell, "ann", ann_model, ann_training_err, ann_val_err);     
end

function save_model(i_cell, model_name, model_obj, train_error, val_error)
    models_path = "_data/models_unique2repeated/";
%     models_path = "_data/models_train2test/";
    
    mat_file = strcat(models_path, "cell", string(i_cell), ".mat");
    model.(model_name) = model_obj;
    model.(strcat(model_name, "_training_err")) = train_error;
    model.(strcat(model_name, "_val_err")) = val_error;
    
    if exist(mat_file, 'file')
        save(mat_file, '-struct', 'model', '-append');
    else
    	save(mat_file, '-struct', 'model');
    end        
end
