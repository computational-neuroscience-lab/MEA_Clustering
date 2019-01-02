load("Sta.mat", "STAs")
save("Sta_not_flipped(old).mat", "STAs")

stas_old = STAs;
STAs = {};
for iCell = 1:length(stas_old)
    for t = 1:size(stas_old{1},3)
        STAs{iCell}(:,:,t) = flip(stas_old{iCell}(:,:,t)',2);
    end
end
save("Sta.mat", "STAs")