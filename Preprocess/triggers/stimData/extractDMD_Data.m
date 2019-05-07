function data = extractDMD_Data(rawFile)

iChannel = 127;  % trigger DMD
data = extractStimData(rawFile, iChannel);
