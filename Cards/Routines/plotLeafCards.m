function plotLeafCards(class, experiments)

if ~exist('experiments', 'var')
    load(getDatasetMat(), 'experiments');
end

if ~exist('class','var')
    subclasses = getLeafClasses();
else
    subclasses = getLeafClasses(class);
end

if numel(subclasses) > 0
    for class = subclasses
        plotClassCard(class, experiments);
    end
end


