clear
close all

% Data Paths
models_path = "_data/models_unique2repeated/";
dh_mat = "_data/dh_train_set.mat";

% load the datasets
load(dh_mat, "x_repeated", "y_repeated");
x_test = x_repeated;
y_test = y_repeated;
n_cells = size(y_test, 1);

% iterate over good cells (selected manually by looking at DH_PSTHs)
selected_cell_indices = [6, 10, 20, 24, 30, 36, 38, 41, 46, 51, 57, 60, 64, 82];
 
 for i_cell = selected_cell_indices
    
    y_test_cell = y_test(i_cell, :);

    % load the ANN
    file_mat = strcat(models_path, "cell", string(i_cell));
    load(file_mat, 'perc', 'perc_training_err', 'perc_val_err'); 
    load(file_mat, 'ln', 'ln_training_err', 'ln_val_err'); 
    load(file_mat, 'ann', 'ann_training_err', 'ann_val_err'); 
    
    % test
    fprintf("testing...\n");
    y_perceptron = perc.process_all(x_test);
    y_ln_model= ln.process_all(x_test);
    y_ann_model = ann.process_all(x_test);

    % pearson correlation
    pcorr_perceptron = corr(y_perceptron.', y_test_cell.');
    pcorr_ln_model = corr(y_ln_model.', y_test_cell.');
    pcorr_ann_model = corr(y_ann_model.', y_test_cell.');
    
    disp(strcat("Perceptron PearsonCorr = ", string(pcorr_perceptron)));
    disp(strcat("LN MODEL PearsonCorr = ", string(pcorr_ln_model)));
    disp(strcat("ANN MODEL PearsonCorr = ", string(pcorr_ann_model)));
    
    % plot validation
    figure;
    
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 500;
    horz = 1500;
    set(gcf,'Position',[(width/2)-horz/2, (height*3/4)-vert/2, horz, vert]);
    
    subplot(1,3,1);
    plotModelError(y_perceptron, y_test_cell);
    title("Perceptron")
    subplot(1,3,2);
    plotModelError(y_ln_model, y_test_cell);
    title("LN Model")
    subplot(1,3,3);
    plotModelError(y_ann_model, y_test_cell);
    title("ANN Model")
    suptitle(strcat("Cell #", string(i_cell), ": Model/Data Output Correlation"));
      
    % plot error
    figure;
    
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 500;
    horz = 1500;
    set(gcf,'Position',[(width/2)-horz/2, (height/4)-vert/2, horz, vert]);
    
    subplot(1,3,1);
    hold on
    plot(perc_training_err, "LineWidth", 1.8, "Color", [1.0, 0.5, 0.5])
    plot(perc_val_err, "LineWidth", 1.5, "Color", [0.5, 0, 0])
    title("Perceptron")
    xlabel("epochs");
    ylabel("error");
    legend({'Training Error','Validation Error'},'Location','northeast')
    
    subplot(1,3,2);
    hold on
    plot(ln_training_err, "LineWidth", 1.8, "Color", [0.5, 1.0, 0.5])
    plot(ln_val_err, "LineWidth", 1.5, "Color", [0, 0.5, 0])
    title("LN Model")
    xlabel("epochs");
    ylabel("error");
    legend({'Training Error','Validation Error'},'Location','northeast')
    
    subplot(1,3,3);
    hold on
    plot(ann_training_err, "LineWidth", 1.8, "Color", [0.5, 0.5, 1.0])
    plot(ann_val_err, "LineWidth", 1.5, "Color", [0, 0, 0.5])
    title("ANN Model")
    xlabel("epochs");
    ylabel("error");
    legend({'Training Error','Validation Error'},'Location','northeast')
    
    suptitle(strcat("Cell #", string(i_cell), ": Error during Learning"));        

    waitforbuttonpress;
    close all;
end
