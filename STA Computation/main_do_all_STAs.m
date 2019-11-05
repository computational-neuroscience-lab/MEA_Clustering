experiments = ["20190821"];
for experiment = experiments
    disp(strcat("COMPUTING STA FOR EXPERIMENT ", experiment))
    exp_Id = char(experiment);
    main_Offline_STA;
end

