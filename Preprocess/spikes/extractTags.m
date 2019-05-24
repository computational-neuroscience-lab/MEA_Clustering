function Tags = extractTags(templatesFile)

fprintf('Extracting Tags...\n');
Tags = h5read(templatesFile, '/tagged');
fprintf('Extraction Completed\n\n');
