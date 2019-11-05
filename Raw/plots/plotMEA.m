function plotMEA()

figure()

ax1 = axes();

xlim([0.5,16.5]);
ylim([0.5,16.5]);

xticks(1:16)
yticks(1:16)

xline(0.5);
xline(16.5);
yline(0.5);
yline(16.5);

% ax1_pos = ax1.Position;
% ax2 = axes( 'Position',ax1_pos,...
%             'XAxisLocation','top',...
%             'YAxisLocation','right',...
%             'Color','none');
%         
% xlim([0.5,16.5]);
% ylim([0.5,16.5]);
% 
% xticks(1:16)
% yticks(1:16)

xlabel('Electrode Indices (Columns)')
ylabel('Electrode Indices (Rows)')
title('Multi Electrode Array')
hold on


ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 900;
horz = 900;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
