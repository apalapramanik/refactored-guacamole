clc;

% Create a UI figure
fig = uifigure('Name', '3D Point Adjustment');

% Create UI axes
ax = uiaxes(fig, 'Position', [50, 150, 400, 300]);
ax.XLabel.String = 'X-axis';
ax.YLabel.String = 'Y-axis';
ax.ZLabel.String = 'Z-axis';
ax.XLim = [-10, 10];
ax.YLim = [-10, 10];
ax.ZLim = [-10, 10];
view(ax, 45, 30); % Set initial view angle

% Initialize a 3D point
x = 0; y = 0; z = 0;
point = plot3(ax, x, y, z, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
title(ax, 'Adjust the Point Position');

% Add sliders for X, Y, Z
xSlider = uislider(fig, 'Position', [50, 100, 400, 3], 'Limits', [-10, 10], 'Value', 0, 'MajorTicks', -10:5:10);
ySlider = uislider(fig, 'Position', [50, 80, 400, 3], 'Limits', [-10, 10], 'Value', 0, 'MajorTicks', -10:5:10);
zSlider = uislider(fig, 'Position', [50, 60, 400, 3], 'Limits', [-10, 10], 'Value', 0, 'MajorTicks', -10:5:10);

% Set callbacks after sliders are defined
xSlider.ValueChangedFcn = @(sld, event) updatePoint(ax, point, xSlider.Value, ySlider.Value, zSlider.Value);
ySlider.ValueChangedFcn = @(sld, event) updatePoint(ax, point, xSlider.Value, ySlider.Value, zSlider.Value);
zSlider.ValueChangedFcn = @(sld, event) updatePoint(ax, point, xSlider.Value, ySlider.Value, zSlider.Value);


% Function to update the 3D point
function updatePoint(ax, point, newX, newY, newZ)
    % Update the point's data
    point.XData = newX;
    point.YData = newY;
    point.ZData = newZ;
    title(ax, sprintf('Point Position: (%.2f, %.2f, %.2f)', newX, newY, newZ));
end