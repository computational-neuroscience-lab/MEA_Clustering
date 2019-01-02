function data = extractStimData(rawFile, iChannel)

if ~exist('iChannel','var')
    iChannel = 127;  % trigger DMD
end
    
fprintf('Reading Header...\n');
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
end
HeaderSize = HeaderSize+2; % Because there is two characters after the EOH, before the raw data. 

fprintf('Extracting Frames...\n');
fseek(fid,(iChannel-1)*2+HeaderSize,'bof');
data = fread(fid,inf,'uint16',255*2);
data = 0.1042*(double(data)-32767);

fprintf('Extraction Completed\n\n');
