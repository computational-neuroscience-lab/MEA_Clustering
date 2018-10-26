function printLeafCards(expId, class)

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
        % printing
        if isValid
            n = n + 1;
            title = strcat('CLASS#', int2str(n));
            saveas(gcf, title,'pdf')
            close;
        end
    end
end


