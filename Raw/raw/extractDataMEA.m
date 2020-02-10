function mea_snippets = extractDataMEA(raw_file, time_steps, chunk_size, mea_size, encoding)

if strcmp(encoding, 'uint16')
    data_size = 2;   % bite 
elseif strcmp(encoding, 'float32')
    data_size = 4;
else
    error("Data Type %s not supported", encoding)
end

n_reps = length(time_steps);
mea_snippets = zeros(n_reps, mea_size, chunk_size);

header_size = getHeaderSize(raw_file);
fid = fopen(raw_file, 'r');

for i_rep = 1:n_reps
    t = time_steps(i_rep);
    fseek(fid, header_size + mea_size*data_size*t, 'bof');
    data = fread(fid, chunk_size*mea_size, encoding);
    if strcmp(encoding, 'uint16')
        snippet = 0.1042*(double(data)-32767);
    else
        snippet = double(data);
    end
    mea_snippets(i_rep, :, :) = reshape(snippet, mea_size, chunk_size);
end

fclose(fid);