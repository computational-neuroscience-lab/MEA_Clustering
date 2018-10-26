function [SpikeTimes, Frames, Tags] = extractSpikes(resultsFile, templatesFile, rawFile)

% load the spike times
fprintf('Extracting Traces...\n');
SpikeTimes = {};
thereIsTrace = true;
i_trace = 1;
while thereIsTrace
    try
        trace = h5read(resultsFile, ['/spiketimes/temp_' int2str(i_trace - 1)]);
        SpikeTimes{i_trace}  = squeeze(double(trace));
        fprintf('\ttrace %d\n', i_trace);
        i_trace = i_trace + 1;
    catch
        thereIsTrace = false;
    end
end

% load the tags
fprintf('Extracting Tags...\n');
Tags = h5read(templatesFile, '/tagged');

% if it's from the raw data
fprintf('Extracting Frames...\n');

fid = fopen(rawFile,'r');
HeaderText = '';
stop=0;
HeaderSize=0;
while (stop==0)&&(HeaderSize<=10000)%to avoid infinite loop
    ch = fread(fid, 1, 'uint8=>char')';
    HeaderSize = HeaderSize + 1;
    HeaderText = [HeaderText ch];
    if (HeaderSize>2)
        if strcmp(HeaderText((HeaderSize-2):HeaderSize),'EOH')
            stop = 1;
        end
    end
endPer i tre esperimenti 17
HeaderSize = HeaderSize+2; % Because there is two characters after the EOH, before the raw data. 

i=127; % trigger DMD

fseek(fid,(i-1)*2+HeaderSize,'bof');
%data = fread(fid,inf,'uint16',251*2); % original in DMD
data = fread(fid,inf,'uint16',255*2); % in code Olivier
data = 0.1042*(double(data)-32767);

% Analyse Checkerboard
CheckData = data(1:80120000);
Frames = find(CheckData(1:end-1)<=1800 & CheckData(2:end)>1800);

fprintf('Extraction Completed\n\n');
