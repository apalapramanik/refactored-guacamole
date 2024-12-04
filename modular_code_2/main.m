% % Main.m
% clc;
% clear variables;
% warning('off', 'all');
% 
% % Environment setup
% [surfaces, envWidth, envHeight, envDepth] = setupEnvironment();
% 
% % Transmitter setup
% Tx = [30, 20, 5]; % Example transmitter position
% plotTransmitter(Tx);
% 
% % Generate rays and handle reflections
% plotRays(Tx, surfaces);
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
Tx = [30, 20, 5]; % Example transmitter position
plotTransmitter(Tx);
txPower = 40;
reflection_coefficient = 0.65;



% Generate rays and handle reflections
plotRays(Tx, surfaces, txPower, reflection_coefficient);

hold off;
view(3); % Set 3D view
title('3D Environment with Ray Tracing, Antenna Pattern, and Up to Two Reflections');

function plotRays(Tx, surfaces, txPower, reflection_coefficient)
    % Generate and reflect rays using all surfaces
    plotRaysWithReflections(Tx, surfaces, txPower, reflection_coefficient);
end


