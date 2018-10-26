%Script to get the event marker

FileBase = '/Volumes/Elements 1/20180705/DH_NOBCKGR';

ElectrodesFile = [FileBase '.raw'];
StimFile = 'DH_NOBCKGR.mat';

EvtChannel = 128; %channel of the stimulation
EvtThreshold = 100; % threshold for the simulation square wave

fid = fopen(ElectrodesFile,'r');

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

HeaderSize = HeaderSize+2;%Because there is two characters after the EOH, before the raw data. 

i=EvtChannel;

fseek(fid,(i-1)*2+HeaderSize,'bof');
data = fread(fid,inf,'uint16',255*2);

data = 0.1042*(double(data)-32767);


StimBegin = find(data(1:end-1)<EvtThreshold & data(2:end)>=EvtThreshold )+1;
StimEnd = find(data(1:end-1)>EvtThreshold & data(2:end)<=EvtThreshold )+1;

figure;
plot(data)
hold on
plot(StimBegin,data(StimBegin),'r.','MarkerSize',20)
plot(StimEnd,data(StimEnd),'g.','MarkerSize',20)
hold off

save(StimFile,'StimBegin','StimEnd','-mat');
