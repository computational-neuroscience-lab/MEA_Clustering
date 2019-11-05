function snippets = extractDataElectrode(raw_file, electrode_id, time_steps, chunk_size, mea_size, encoding)

if strcmp(encoding, 'uint16')
    data_size = 2;   % bite
elseif strcmp(encoding, 'float32')
    data_size = 4;
else
    error("Data Type %s not supported", encoding)
end

n_reps = length(time_steps);
snippets = zeros(n_reps, chunk_size);

header_size = getHeaderSize(raw_file);
fid = fopen(raw_file, 'r');

for i_rep = 1:n_reps
    t = time_steps(i_rep);
    location = header_size + (electrode_id - 1)*data_size + mea_size*data_size*t;
    fseek(fid, location, 'bof');
    data = fread(fid, chunk_size, encoding, (mea_size - 1)*data_size);
    if strcmp(encoding, 'uint16')
        snippets(i_rep, :) = 0.1042*(double(data)-32767);
    else
        snippets(i_rep, :) = double(data);
    end
end