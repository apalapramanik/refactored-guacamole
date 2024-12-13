clc;
clear variables;
warning('off', 'all');

%figure setup
fig = uifigure('Name', '3D Environment');
ax = uiaxes(fig, 'Position', [50, 150, 400, 300]);
ax.XLabel.String = 'X-axis';
ax.YLabel.String = 'Y-axis';
ax.ZLabel.String = 'Z-axis';
ax.XLim = [0, 50];
ax.YLim = [0, 50];
ax.ZLim = [0, 20];
view(ax, 45, 30); % Set initial view angle


% Transmitter setup
Tx = [10, 10, 5]; % Example transmitter position
txpos = plotTransmitter(ax, Tx);
grid on;

% Environment setup
%[surfaces, envWidth, envHeight, envDepth] = setupEnvironment_old();


% Generate rays and handle reflections
%plotRays(Tx, surfaces);

% hold off;
% view(3); % Set 3D view
% title('3D Environment with Ray Tracing, Antenna Pattern, and Up to Two Reflections');
% 
% function plotRays(Tx, surfaces)
%     % Generate and reflect rays using all surfaces
%     plotSimple(Tx, surfaces);
% end