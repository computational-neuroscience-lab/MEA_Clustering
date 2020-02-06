function [ws_norm, a, b] = getDHLNPWeights(session_label, model, i_cell)

dh_session_struct = load(getDatasetMat, session_label);

ws = dh_session_struct.(session_label).(model).ws;
b = dh_session_struct.(session_label).(model).b;

a = max(abs(ws), [], 2);
ws_norm = ws ./ repmat(a, 1, size(ws,2));

if exist('i_cell', 'var')
    a = a(i_cell);
    b = b(i_cell);
    ws_norm = ws_norm(i_cell, :);
end