function y_labels = yPatternLabels(patterns)

n_patterns = size(patterns, 1);
y_labels = strings(1, n_patterns);
for i_pattern = 1:n_patterns
    p = patterns(i_pattern, :);
    p_elements = find(p);
    
    p_strengths = p(p_elements);
    if range(p_strengths) == 0
        p_strengths = p_strengths(1);
    end
        
    y_labels(i_pattern) = strcat(mat2str(p_elements), "   ", mat2str(p_strengths, 3)) ;
end