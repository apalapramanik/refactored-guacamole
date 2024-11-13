% Define coordinates
x = [0];
y = [0];
z = [0];

% Create 3D line plot
figure;
plot3(x, y, z, 'b-', 'LineWidth', 2);
grid on;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Line Plot');