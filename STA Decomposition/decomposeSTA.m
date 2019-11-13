function [temporal, spatial, rfs, indices, qualityIndices] = decomposeSTA(stas, doSmoothing, doPlot)

if ~exist('doSmoothing', 'var')
    doSmoothing = true;
end

if ~exist('doPlot', 'var')
    doPlot = false;
end

logical_indices = boolean(zeros(1, length(stas)));
qualityIndices = zeros(1, length(stas));

for i=1:length(stas)
    
    if sum(stas{i}(:)) == 0
        logical_indices(i) = false;
    else
        
        % filter the sta to remove some noise
        if doSmoothing
            smoothSTA = smoothSta(stas{i});
            staFrame = std(smoothSTA, [], 3);
        else
            staFrame = std(stas{i}, [], 3);
        end
        
        % Fit The ellipses
        [xEll, yEll, ~, ~] =  fitEllipse(staFrame);
        [isValid, meanRatio] = validateEllipse(xEll, yEll, staFrame);
        
        % extract temporal
        [tSta, ~, ~] = extractTemporalSta(stas{i}, xEll, yEll);

        % return structures
        logical_indices(i) = isValid;
        qualityIndices(i) = meanRatio;
        
        if isValid
            temporal(i, :) = tSta;
            spatial(i, :, :) = std(stas{i}, [], 3);
            rfs(i) = polyshape(xEll, yEll);
        end
        
        % debugging plots
        if doPlot
            figure()
            subplot(1,2,1)
            imagesc(staFrame)
            hold on
            plot(xEll, yEll, "r", "LineWidth", 3)
            scatter(xCenter, yCenter, "k", "LineWidth", 5)
            title(strcat("Smoothed Spatial STA (meanRatio = ", string(meanRatio), ")"))
            
            subplot(1,2,2)
            hold on
            plot(tSta_out, "b")
            plot(tSta_in, "r", "LineWidth", 2)
            plot(tSta, "k", "LineWidth", 3)
            title(strcat("Smoothed Temporal STAs"))
            
            % set figure position and scaling
            ss = get(0,'screensize');
            width = ss(3);
            height = ss(4);
            vert = 800;
            horz = 1600;
            set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
            
            waitforbuttonpress;
            close
        end
        
    end
end
indices = find(logical_indices);








