function indices = classExpIndices(typeId, experiment)
indices = and(classIndices(typeId), expIndices(experiment));