function exp_id = getExpId()

load(getDatasetMat, 'experiments');
if(numel(experiments) == 1)
    exp_id = char(experiments{1});
else
    error('getExpId error: Current Dataset contains multiple experiments.')
end
