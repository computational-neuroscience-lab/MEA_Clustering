function setDataPath(data_path_code)
global data_path
if strcmp(data_path_code, 'storage')
    path = '/storage/Francesco/Experiments';
    
elseif strcmp(data_path_code, 'server')
    home_folder = char(java.lang.System.getProperty('user.home'));
    path = [home_folder '/hodgkin/Public/Francesco/MEA_Experiments'];
    
elseif strcmp(data_path_code, 'local')
    home_folder = char(java.lang.System.getProperty('user.home'));
    path = [home_folder '/Data'];
    
elseif strcmp(data_path_code, 'drive')
    path = '/media/fran_tr/Fran_MEA-I/MEA_Experiments';
    
else
    error('Unknown data path. Choose among: server/storage/local/drive')
end

if exist(path, 'dir')
    data_path=path;
else
    error('Invalid data path.')
end

