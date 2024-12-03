% Main.m
% clc;
% clear variables;
% warning('off', 'all');
% 
% % Environment setup
% [surfaces, envWidth, envHeight, envDepth] = setupEnvironment();
% 
% % Transmitter setup
% Tx = [25, 25, 5]; % Example transmitter position
% plotTransmitter(Tx);
% 
% % Create vertically polarized mmWave antenna
% ant = create60GHzVPolarizedAntenna();
% 
% % Generate rays and handle reflections
% plotRaysWithReflections(Tx, surfaces, ant);
% 
% hold off;
% view(3); % Set 3D view
% title('3D Environment with Ray Tracing and Up to Two Reflections');
% 
% function plotRays(Tx, surfaces)
%     % Generate and reflect rays using all surfaces
%     plotRaysWithReflections(Tx, surfaces);
% end

clc;
clear variables;
warning('off', 'all');

% Environment setup
[surfaces, envWidth, envHeight, envDepth] = setupEnvironment();

% Transmitter setup
Tx = [25, 25, 5]; % Example transmitter position
plotTransmitter(Tx);

% Create horizontally polarized mmWave antenna
ant = create60GHzHPolarizedAntenna();

% Generate rays and handle reflections
figure;
hold on;
plotRaysWithReflections(Tx, surfaces, ant); % Pass antenna to ray tracing
hold off;

% Final view settings
view(3); % Set 3D view
title('3D Environment with Ray Tracing and Up to Two Reflections');

