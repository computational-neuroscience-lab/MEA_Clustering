function [t_img, t_ref] = transformImage(h, img, img_ref)

t = projective2d(transpose(h));

if ~exist('img_ref', 'var')
    img_ref = imref2d(size(img), [0,size(img,2)], [0,size(img,1)]);
end

[t_img, t_ref] = imwarp(img, img_ref, t, 'interp', 'nearest');
