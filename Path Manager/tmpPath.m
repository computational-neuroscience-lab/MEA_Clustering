function path = tmpPath()

home_folder = char(java.lang.System.getProperty('user.home'));
path = [home_folder '/Tmp_Vars'];
