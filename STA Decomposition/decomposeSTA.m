function [temporal, spatial, indices, qualityIndices] = decomposeSTA(stas)

for i=1:length(stas)
         
        if sum(stas{i}(:)) == 0
            logical_indices(i) = false;
        else

        % filter the sta to remove some noise
        smoothSTA = smoothSta(stas{i});

        % Fit The ellipses
        staFrame = std(smoothSTA, [], 3);
        [xEll, yEll, xCenter, yCenter] =  fitEllipse(staFrame);
        [isValid, meanRatio] = validateEllipse(xEll, yEll, staFrame);

        % extract temporal
        [tSta, tSta_in, tSta_out] = extractTemporalSta(stas{i}, xEll, yEll);

        % return structures
        logical_indices(i) = isValid;
        if isValid
            qualityIndices(i) = meanRatio;

            temporal(i, :) = tSta;

            spatial(i).x = xEll;
            spatial(i).y = yEll;
            spatial(i).centerX = xCenter;
            spatial(i).centerY = yCenter;
        end

%         % debugging plots
%         figure()
%         subplot(1,2,1)
%         imagesc(staFrame)
%         hold on
%         plot(xEll, yEll, "r", "LineWidth", 3)
%         scatter(xCenter, yCenter, "k", "LineWidth", 5)
%         title(strcat("Smoothed Spatial STA (meanRatio = ", string(meanRatio), ")"))
% 
%         subplot(1,2,2)
%         hold on
%         plot(tSta_out, "b")
%         plot(tSta_in, "r", "LineWidth", 2)
%         plot(tSta, "k", "LineWidth", 3)
%         title(strcat("Smoothed Temporal STAs"))
% 
%         % set figure position and scaling
%         ss = get(0,'screensize');
%         width = ss(3);
%         height = ss(4);
%         vert = 800;
%         horz = 1600;
%         set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
% 
%         waitforbuttonpress;
%         close  
        
        end
end
indices = find(logical_indices);








