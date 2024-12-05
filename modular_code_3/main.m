clc;
clear variables;
warning('off', 'all');

% Environment setup
[surfaces, envWidth, envHeight, envDepth] = setupEnvironment();

% Transmitter setup
Tx = [42, 20, 5]; % Example transmitter position
plotTransmitter(Tx);

% Parameters
txPower = 15; % Transmit power in dBm
reflection_coefficient = 0.6; % Reflection coefficient
freq = 24e9; % Frequency in Hz
pathLossExponent = 3; % Path loss exponent (n)
shadowingStdDev = 8; % Log-normal shadowing standard deviation (\sigma)

% Generate rays and handle reflections
plotRaysWithReflections(Tx, surfaces, txPower, reflection_coefficient, freq, pathLossExponent, shadowingStdDev);

% Adjust 3D view
a = -0;
e = 90; 
view(a, e); % Set 3D view -40,60

% Add plot title
title('3D Environment with Ray Tracing');

% Add color gradient scale
addColorGradientScale();

% Add parameter details to the plot
addParameterDetails(Tx, txPower, reflection_coefficient, freq, pathLossExponent, shadowingStdDev);

hold off;

% Function to add a color gradient scale for power levels
function addColorGradientScale()
    % Define the range of power levels
    minPr = -100; % Minimum power level (in dBm)
    maxPr = 0;   % Maximum power level (in dBm)

    % Add a color bar to the plot
    colormap(jet(256)); % Use the 'jet' colormap
    c = colorbar;
    c.Label.String = 'Received Power (dBm)';
    c.Label.FontSize = 10;
    c.Ticks = linspace(0, 1, 7); % Set ticks for the color bar
    c.TickLabels = num2cell(linspace(minPr, maxPr, 7)); % Map ticks to power levels
end

% Function to add parameter details to the plot
function addParameterDetails(Tx, txPower, reflection_coefficient, freq, pathLossExponent, shadowingStdDev)
    % Create a string with the parameter details
    paramDetails = sprintf(['Transmitter Position: [%.2f, %.2f, %.2f]\n', ...
                            'Transmit Power: %.2f dBm\n', ...
                            'Reflection Coefficient: %.2f\n', ...
                            'Frequency: %.2f GHz\n', ...
                            'Path Loss Exponent: %.2f\n', ...
                            'Shadowing Std Dev: %.2f dB'], ...
                            Tx(1), Tx(2), Tx(3), txPower, reflection_coefficient, freq / 1e9, pathLossExponent, shadowingStdDev);

    % Add the details to the plot as a textbox annotation
    annotation('textbox', [0.7, 0.1, 0.2, 0.2], ... % [x, y, width, height]
               'String', paramDetails, ...
               'FitBoxToText', 'on', ...
               'EdgeColor', 'black', ...
               'BackgroundColor', 'white', ...
               'FontSize', 10, ...
               'HorizontalAlignment', 'left');
end
