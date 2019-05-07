function H = getHomography(reference_frame1 ,reference_frame2)
homographies_path = [projectPath '/Homographies/Homographies.mat'];
homography = ['H_' reference_frame1 '2' reference_frame2];
h_struct = load(homographies_path, homography);
H = h_struct.(homography);


