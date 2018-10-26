function plotLeafCards(expId, class)

if ~exist('class','var')
    subclasses = getLeafClasses();
else
    subclasses = getLeafClasses(class);
end

n = 0;
if numel(subclasses) > 0
    for class = subclasses
        if ~exist('expId','var')
            isValid = plotClassCard(class);
        else
            isValid = plotClassCard(class, expId);
        end
    end
end


