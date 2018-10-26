function plotLeafClusters(class, minClassSize, maxSublevels)

if ~exist('maxSublevels','var') &&  ~exist('minClassSize','var')
    subclasses = getLeafClasses(class);
elseif ~exist('maxSublevels','var')
    subclasses = getLeafClasses(class, minClassSize);
else
    subclasses = getLeafClasses(class, minClassSize, maxSublevels);
end
    
if numel(subclasses) > 0
    plotClassClusters(subclasses,  getPCASpace(class));
end
