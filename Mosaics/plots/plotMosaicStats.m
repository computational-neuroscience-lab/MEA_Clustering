function plotMosaicStats(label_set, label_exp, coverage, rfs_uniques, rfs_duplicate, nnnds, null_nnnds, p_val)

figure()

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 800;
horz = 1200;
set(gcf,'Position',[(width-horz)/2, (height-vert)/2, horz, vert]);
st = suptitle([char(label_set) ' Mosaic for exp #' char(label_exp)]);
st.Interpreter = 'none';

subplot(2, 3, [1,2,4,5])
plotCoverageMap(coverage, rfs_uniques, rfs_duplicate);

subplot(2, 3, 3)
plotCoverageHisto(coverage);

subplot(2, 3, 6)
plotNNNDs(nnnds, null_nnnds, p_val);
