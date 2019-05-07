function data = extractDH_Data(rawFile)

iChannel = 128;  % trigger DH
data = extractStimData(rawFile, iChannel);
