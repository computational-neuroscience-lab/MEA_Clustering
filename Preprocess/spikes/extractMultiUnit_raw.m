function multi_unit = extractMultiUnit_raw(electrodes_file, stim_begin, duration)

n_MEA = 256;
n_reps = length(stim_begin);
multi_unit = zeros(n_MEA, n_reps, duration);

% Read From Files
fid = fopen(electrodes_file,'r');

% Read Header
header_txt = fread(fid, 3, 'uint8=>char')';
header_len = 3;

while ~strcmp(header_txt((header_len-2):header_len),'EOH') && (header_len<=10000) % to avoid infinite loop
    ch = fread(fid, 1, 'uint8=>char')';
    header_len = header_len + 1;
    header_txt = [header_txt ch];
end
% there are two characters after the EOH, before the raw data.
header_len = header_len + 2;

% Read Data
for i_rep = 1:n_reps
    
    fseek(fid, header_len + 2*n_MEA*stim_begin(i_rep), 'bof');
    data = fread(fid, n_MEA*duration, 'uint16');
    data = 0.1042 * (double(data)-32767);

   multi_unit(:, i_rep, :) = reshape(data,[n_MEA duration]);
end
