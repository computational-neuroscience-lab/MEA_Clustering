function SpikeTimes = extractSpikeTimes(resultsFile)

% load the spike times
fprintf('Extracting Traces...\n');
SpikeTimes = {};
thereIsTrace = true;
i_trace = 1;
while thereIsTrace
    try
        trace = h5read(char(resultsFile), ['/spiketimes/temp_' int2str(i_trace - 1)]);
        SpikeTimes{i_trace}  = double(trace(:));
        fprintf('\ttrace %d\n', i_trace);
        i_trace = i_trace + 1;
    catch
        thereIsTrace = false;
    end
end
fprintf('Extraction Completed\n\n');
