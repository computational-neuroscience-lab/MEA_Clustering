experiments = ["20190510"];
for experiment = experiments
    disp(strcat("COMPUTING STA FOR EXPERIMENT ", experiment))
    exp_Id = char(experiment);
    main_Offline_STA;
end

