clc;
clear variables;
warning('off', 'all');

% Environment setup
[surfaces, envWidth, envHeight, envDepth] = setupEnvironment();

% Transmitter setup
Tx = [40, 20, 5]; % Example transmitter position
plotTransmitter(Tx);

% Parameters
txPower = 20; % Transmit power in dBm
reflection_coefficient = 0.6; % Reflection coefficient
freq = 60e9; % Frequency in Hz
pathLossExponent = 3; % Path loss exponent (n)
shadowingStdDev = 8; % Log-normal shadowing standard deviation (\sigma)

% Generate rays and handle reflections
plotRaysWithReflections(Tx, surfaces, txPower, reflection_coefficient, freq, pathLossExponent, shadowingStdDev);

% Adjust 3D view
a = -40;
e = 60;
view(a, e); % Set 3D view
title('3D Environment with Ray Tracing, Antenna Pattern, and Up to Two Reflections');

hold off;
