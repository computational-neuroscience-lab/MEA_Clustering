function extractDH(expId)

expId = char(expId);
rawPath = [dataPath() '/' expId '/sorted/CONVERTED'];
varsPath = [dataPath() '/' expId '/processed/DHSpots/'];

% File Paths
rawFile = strcat(rawPath, '.raw');


% Stim Triggers
try
    load(strcat(varsPath,'DHTimes.mat'), 'dhTimes')
    disp("DHtTimes Loaded")
catch
    try
        load([varsPath 'DHChannel_data.mat'], 'DHChannel_data')
    catch
        DHChannel_data = extractDH_Data(rawFile);
        save([varsPath 'DHChannel_data.mat'], 'DHChannel_data', '-v7.3');
    end
    dhTimes = extractDHTriggers(DHChannel_data);
    save([varsPath 'DHTimes.mat'], 'dhTimes')
end
 