function printExpLeafCards(expId, class)

if ~exist('class','var')
    subclasses = getLeafClasses();
else
    subclasses = getLeafClasses(class);
end

if numel(subclasses) > 0
    for c = subclasses
        classNotEmpty = plotExpClassCard(c, expId);
        if classNotEmpty
            saveas(gcf, regexprep(c, '\.', '_'),'jpg')
            close;
        end
    end
end


