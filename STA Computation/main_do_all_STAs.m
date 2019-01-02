experiments = ["20170614", "20180209", "20180705", "20181017", "20181018a", "20181018b"];
for experiment = experiments
    disp(strcat("COMPUTING STA FOR EXPERIMENT ", experiment))
    exp_Id = char(experiment);
    main_Offline_STA;
end

