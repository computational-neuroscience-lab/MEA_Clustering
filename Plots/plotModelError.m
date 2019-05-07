function plotModelError(y_model ,y_true)

assert(size(y_model, 1) == 1);
assert(size(y_true, 1) == 1);
assert(size(y_true, 2) == size(y_model, 2));

scatter(y_model, y_true, 15, 'r', 'filled', 'o');
hold on
y_min = min([y_model, y_true]);
y_max = max([y_model, y_true]);
plot([y_min, y_max], [y_min, y_max], "LineWidth", 1.5, "Color", [.2, .2, .2])

xlabel("model output");
ylabel("ground truth output");
title("Model Validation Test");