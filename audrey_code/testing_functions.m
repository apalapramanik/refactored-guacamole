clc;
clear variables;
fprintf("start\n\n");
% Define the position of the transmitter [x, y, z]
transmitter_position = [0, 0, 0];

% Create a Transceiver object
transceiver = transceiver_model(transmitter_position, 20, 15, 28); % Power = 20 dBm, Gain = 15 dBi, Frequency = 28 GHz

% Generate 10 rays
rays = transceiver.generateRays(10);

% Display properties of each ray
for i = 1:length(rays)
    fprintf('Ray %d:\n', i);
    fprintf('  Position: [%.2f, %.2f, %.2f]\n', rays(i).Position);
    fprintf('  Direction: [%.2f, %.2f, %.2f]\n', rays(i).Direction);
    fprintf('  Power: %.4f W\n', rays(i).Power);
end