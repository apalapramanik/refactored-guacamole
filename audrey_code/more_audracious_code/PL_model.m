clc;
clear variables;

% Coordinates of transmitter, receiver, and wall
tx = [1, 7, 5];  % Transmitter position
rx = [6, 10, 6];  % Receiver position
wall_x = 0;      % Wall location

% Visualize the environment
figure;
% Plot the transmitter and receiver
plot3(tx(1), tx(2), tx(3), 'ro', 'MarkerSize', 8, 'DisplayName', 'Transmitter');
hold on;
plot3(rx(1), rx(2), rx(3), 'bo', 'MarkerSize', 8, 'DisplayName', 'Receiver');
hold on;
grid on;
axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');




% LOS Path (direct)
plot3([tx(1), rx(1)], [tx(2), rx(2)], [tx(3), rx(3)], 'k--', 'DisplayName', 'LOS Ray');
hold on;
% Ground-reflected path
ground_reflection_point = [tx(1), tx(2), 0];  % Reflection point on the ground
plot3([tx(1), ground_reflection_point(1), rx(1)], ...
      [tx(2), ground_reflection_point(2), rx(2)], ...
      [tx(3), ground_reflection_point(3), rx(3)], 'g--', 'DisplayName', 'Ground Reflected Ray');

% Wall-reflected path
wall_reflection_point = [wall_x, tx(2), tx(3)];  % Reflection point on the wall
plot3([tx(1), wall_reflection_point(1), rx(1)], ...
      [tx(2), wall_reflection_point(2), rx(2)], ...
      [tx(3), wall_reflection_point(3), rx(3)], 'b--', 'DisplayName', 'Wall Reflected Ray');

% Plot the wall
fill3([wall_x, wall_x, wall_x, wall_x], [-2, 12, 12, -2], [0, 0, 6, 6], [0.8 0.8 0.8], 'FaceAlpha', 0.5, 'DisplayName', 'Wall');
% 
legend;
title('Ray Tracing Environment with LOS and Reflected Rays');
% 
% % Calculate the path lengths
d_LOS = norm(tx - rx);   % Direct LOS path
d_ground = norm(tx - ground_reflection_point) + norm(ground_reflection_point - rx);
d_wall = norm(tx - wall_reflection_point) + norm(wall_reflection_point - rx);

% Define transmitter power and wavelength
P_tx = 1; % Transmit power in watts
lambda = 0.3; % Wavelength in meters (for example, 1 GHz frequency)

% Calculate the received power for each path
P_LOS = P_tx * (lambda / (4 * pi * d_LOS))^2;
P_ground = P_tx * (lambda / (4 * pi * d_ground))^2 * 0.5; % Assuming 50% reflection coefficient
P_wall = P_tx * (lambda / (4 * pi * d_wall))^2 * 0.7;     % Assuming 70% reflection coefficient

% Calculate total received power
% Phase differences due to path lengths
phi_LOS = 2 * pi * d_LOS / lambda;
phi_ground = 2 * pi * d_ground / lambda;
phi_wall = 2 * pi * d_wall / lambda;

% Convert to complex amplitudes
E_LOS = sqrt(P_LOS) * exp(1j * phi_LOS);
E_ground = sqrt(P_ground) * exp(1j * phi_ground);
E_wall = sqrt(P_wall) * exp(1j * phi_wall);

% Sum the complex amplitudes and calculate total power
E_total = E_LOS + E_ground + E_wall;
P_total = abs(E_total)^2;

P_LOS = log10(P_LOS);
P_ground = log10(P_ground);
P_wall = log10(P_wall);
P_total = log10(P_total);

% Display calculated powers
fprintf('LOS Power: %.4f dBW\n', P_LOS);
fprintf('Ground Reflected Power: %.4f dBW\n', P_ground);
fprintf('Wall Reflected Power: %.4f dBW\n', P_wall);
fprintf('Total Received Power: %.4f dBW\n', P_total);