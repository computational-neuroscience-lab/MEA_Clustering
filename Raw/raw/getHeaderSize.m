function header_size = getHeaderSize(raw_file)

HEADER_MAX = 10000;

header_txt = '';
header_size = 0;
is_header = true;

fid = fopen(raw_file,'r');
while is_header
    header_size = header_size + 1;
    header_txt = [header_txt fread(fid, 1, 'uint8=>char')'];
    
    if (header_size > 2)
        if strcmp(header_txt((header_size - 2):header_size), 'EOH')
            is_header = false;
        end
    end
    if header_size > HEADER_MAX
        warning('%s: HEADER NOT FOUND', raw_file)
        header_size = 0;
        return
    end
end
fclose(fid);

% Because there is two characters after the EOH, before the raw data.
header_size = header_size + 2;
