function plotSubTraces(classId)
subclasses = getSubclasses(classId);
if numel(subclasses) > 0
    plotClassTraces(subclasses, strcat(classId, ": Average Subclasses Response"));
end
