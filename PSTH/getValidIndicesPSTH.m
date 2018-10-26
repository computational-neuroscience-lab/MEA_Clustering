function indices = getValidIndicesPSTH(PSTH)

logicalIndices = ones(size(PSTH, 1), 1);
for icell = 1:size(PSTH, 1)
    if sum(PSTH(icell, :)) == 0
        logicalIndices(icell) = 0;
    end
end

indices = find(logicalIndices);

