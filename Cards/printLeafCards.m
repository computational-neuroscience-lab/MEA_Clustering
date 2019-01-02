function printLeafCards(expId, class)

if ~exist('class','var')
    subclasses = getLeafClasses();
else
    subclasses = getLeafClasses(class);
end

if numel(subclasses) > 0
    for class = subclasses
        if ~exist('expId','var')
            plotClassCard(class);
        else
            plotClassCard(class, expId);
        end
        saveas(gcf, regexprep(class, '\.', '_'),'jpg')
        close;
    end
end


