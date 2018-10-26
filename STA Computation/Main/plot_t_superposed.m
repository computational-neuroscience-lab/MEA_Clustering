%for each check plot the temporal trace

load('/Users/giuliaspampinato/Desktop/20180705/SpikeTimes.data_STA_21TimeBins.mat')

time = (-20:0)*0.33;
for iCell=30:36%length(STAs) 
    figure
    %title(['electrode ' int2str(iCell)])
    
    for x=1:size(STAs{iCell},1)
        for y=1:size(STAs{iCell},2)
            TemporalCheck = squeeze(STAs{iCell}(x,y,:));
            plot(time,TemporalCheck)
            hold on
        end
    end
    title(['electrode ' int2str(iCell)])
end