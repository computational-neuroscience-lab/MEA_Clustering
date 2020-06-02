clear
close all

i_cell = 3;
exp_id = '20180705_discs';

loadDataset();
discs_100_idx = [discs_reps.diameter] == 100;
discs_100 = discs_reps(discs_100_idx);


% get STA and transform it
sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

H1 = getHomography('dmd', 'img');
H2 = getHomography(['img1'], 'mea', exp_id);

[sta_2mea, staRef_2mea] = transformImage(H2*H1, sta);
img_rgb = ind2rgb(sta_2mea, colormap('summer'));
imshow(img_rgb, staRef_2mea);
hold on



for i_disc = 1:numel(discs_100)
    x = discs_100(i_disc).center_x_mea;
    y = discs_100(i_disc).center_y_mea;
	viscircles([x, y], 50) 
    
end

for ix = 1:16
    for iy = 1:16
        scatter(ix*30, iy*30, 'b*')
    end
end

%  labels and colorbars
xlabel('Microns');
ylabel('Microns');