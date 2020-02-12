function path = dataPath()
global data_path

if ~isempty(data_path)
    path = data_path;
else
    home_folder = char(java.lang.System.getProperty('user.home'));
    path = [home_folder '/hodgkin/Public/Francesco/MEA_Experiments'];
end