function path = projectPath()

home_folder = char(java.lang.System.getProperty('user.home'));
path = [home_folder '/Projects/MEA_CLUSTERING'];

