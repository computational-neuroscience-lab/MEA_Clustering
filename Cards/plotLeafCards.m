function plotLeafCards(class)

if ~exist('class','var')
    subclasses = getLeafClasses();
else
    subclasses = getLeafClasses(class);
end

if numel(subclasses) > 0
    for class = subclasses
        plotClassCard(class);
    end
end


