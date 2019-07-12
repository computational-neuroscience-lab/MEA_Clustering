function expression = computeSpotsExpression(experiment)

thresh_acc = .6;
thresh_expression = .5;

a = getDHLNPAccuracies(experiment);
ws = getDHLNPWeights(experiment);
spots_2img = getDHSpotsCoordsImg(experiment);

expression = logical(max(abs(ws(a > thresh_acc, :)) > thresh_expression));

% figure
% ss = get(0,'screensize');
% width = ss(3);
% height = ss(4);
% vert = 600;
% horz = 900;
% set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
% 
% scatter(spots_2img(expression,1), -spots_2img(expression,2), 30, 'r', "Filled")
% hold on
% scatter(spots_2img(~expression,1), -spots_2img(~expression,2), 30, 'k', "Filled")
% axis off
