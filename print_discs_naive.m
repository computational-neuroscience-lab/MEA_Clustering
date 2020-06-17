loadDataset();

offset = 3000;
duration = 3000;

i_cell = 16;
figure()
hold on;
i_row = 1;
spikes_train = spikes{i_cell};
for i_rep = 1:numel(discs.rep_begin)
    r = discs.rep_begin(i_rep)-offset;
	train = spikes_train((spikes_train > r) & (spikes_train <  r+duration+2*offset));
    train = train - r;
    i_row = i_row + 1;
    scatter(train, ones(1, numel(train))*i_row, 'b', 'Filled')
end
xline(offset, 'r');
xline(duration+offset, 'r');
    
% exp_id = getExpId();
% path = [dataPath '/' exp_id '/processed/Discs/Plots'];
% 
% for i_cell = 1:numel(spikes)
%     
%     figure();
% 
%     plotStimRaster(spikes{i_cell},  {discs.rep_begin(1:50)}, discs.duration, params.meaRate, ...
%                     'Response_Onset_Seconds', onset, ...
%                     'Response_Offset_Seconds', offset);
%     title(['cell #' num2str(i_cell)])
% 
% %     export_fig([path '/disc_psths_cell#' num2str(i_cell)]);
%     waitforbuttonpress()
%     hold off
% end
