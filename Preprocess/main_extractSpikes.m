% launch this in the folder of the experiment
clear

rawFile = '/media/fran_tr/Elements/20180705/Sorting/CONVERTED.raw';
templatesFile = '/media/fran_tr/Elements/20180705/Sorting/CONVERTED/CONVERTED.templates-fr2.hdf5';
resultsFile = '/media/fran_tr/Elements/20180705/Sorting/CONVERTED/CONVERTED.result-fr2.hdf5';

[SpikeTimes, Frames, Tags] = extractSpikes(resultsFile, templatesFile, rawFile);

save('SpikeTimes.data', 'SpikeTimes')
save('SpikeTimes.mat', 'SpikeTimes')
save('Frames.mat', 'Frames')
save('Tags.mat', 'Tags')
