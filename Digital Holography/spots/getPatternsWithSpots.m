function pattern_idx = getPatternsWithSpots(dh_session, type, spots)

pattern2spots = logical(dh_session.stimuli.(type));
[n_patterns, n_spots] = size(pattern2spots);

if ~islogical(spots)
    spots = logical(sum(ind2vec(spots, n_spots), 2))';
end
pattern_idx = logical(sum(and(pattern2spots, spots), 2));

