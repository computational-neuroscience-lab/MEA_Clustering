function data = extractDataDH(raw_file)

dh_electrode = 128; % We read the DH channel...
time_step = 0;      % ...from the beginning...
chunk_size = inf;    % ...to the end.
encoding = 'unit16';
mea_size = 256;

data = extractDataElectrode(raw_file, dh_electrode, time_step, chunk_size, mea_size, encoding);
