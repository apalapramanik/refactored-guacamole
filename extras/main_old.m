

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
% % txPower = 40;
% % reflection_coefficient = 0.6;
% % freq = 9e9;
% 
% % Parameters
% Tx_power = 20; % Transmit power in dBm
% d = 100; % Distance in meters
% n = 3; % Path loss exponent
% sigma = 8; % Standard deviation for shadowing
% 
% 
% 
% % Generate rays and handle reflections
% plotRays(Tx, surfaces, Tx_power, reflection_coefficient, freq);
% 
% %manually create legend
% 
% % Create a manual key as a "table" in the top-right corner
% keyPosition = [0.1, 0.2]; % Normalized position for bottom-left corner of the key
% boxWidth = 0.05;          % Width of each color box (normalized units)
% boxHeight = 0.03;         % Height of each color box (normalized units)
% textOffset = 0.06;        % Horizontal offset for the text
% 
% % Colors and labels for the key
% colors = ["m", "r", "y", "g", "c", "b", "k"]; 
% labels = strings(1, numel(colors));
% startValue = -10;
% stepSize = 10;
% val = startValue;
% 
% for i = 1:length(colors) - 1
%     labels(i) = sprintf("rx > %.2f dBW", val);
%     val = val - stepSize;
% end
% 
% val = val + stepSize;
% labels(length(colors)) = sprintf("rx <= %.2f dBW", val);
% legend_x = 0.05; % Normalized figure X position
% legend_y = 0.35; % Normalized figure Y position
% box_width = 0.05; % Width of colored boxes (normalized)
% box_height = 0.03; % Height of colored boxes (normalized)
% gap = 0.01; % Gap between boxes and labels
% 
% % Add a title to the legend
% annotation('textbox', ...
%            [legend_x, legend_y + 0.05, 0.2, box_height], ... % Position above legend
%            'String', 'Received Power Levels by Color', 'EdgeColor', 'none', ...
%            'FontWeight', 'bold', 'FontSize', 10, ...
%            'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');
% 
% % Loop to create the legend
% for i = 1:length(labels)
%     % Calculate positions for each row
%     current_y = legend_y - (i - 1) * (box_height + gap);
%     % Add a color box
%     annotation('rectangle', ...
%                [legend_x, current_y, box_width, box_height], ...
%                'FaceColor', colors{i}, 'EdgeColor', 'k');
% 
%     % Add the corresponding text
%     annotation('textbox', ...
%                [legend_x + box_width + gap, current_y, 0.2, box_height], ...
%                'String', labels{i}, 'EdgeColor', 'none', ...
%                'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left');
% end
% 
% % Add a big box around the entire legend
% total_height = length(labels) * (box_height + gap) - gap; % Total height of all rows
% annotation('rectangle', ...
%            [0.04, legend_y - total_height, box_width + 0.12, total_height + box_height + 0.05], ...
%            'EdgeColor', 'k', 'LineWidth', 1.5);
% %create annotation for tx position, power, etc
% textStr = sprintf('Plot Information:\nTx position: x = %.2f, y = %.2f, z = %.2f\nTxPower = %.2f W\nReflection Coefficient = %.2f\nFrequency = %s', Tx(1), Tx(2), Tx(3), txPower, reflection_coefficient, getFreqString(freq));
% 
% % Add a textbox annotation
% annotation('textbox', [0.7, 0.1, 0.2, 0.1], ... % [x, y, width, height] in normalized figure units
%            'String', textStr, ...              % The content of the textbox
%            'FitBoxToText', 'on', ...           % Adjust box size to fit the text
%            'EdgeColor', 'black', ...           % Border color
%            'BackgroundColor', 'white', ...     % Background color
%            'FontSize', 10);                    % Font size
% hold off;
% a = -40;
% e = 60;
% view(a, e); % Set 3D view
% title('3D Environment with Ray Tracing, Antenna Pattern, and Up to Two Reflections');
% 
% function plotRays(Tx, surfaces, txPower, reflection_coefficient, freq)
%     % Generate and reflect rays using all surfaces
%     plotRaysWithReflections(Tx, surfaces, txPower, reflection_coefficient, freq);
% end
% 
% 
% function freqString = getFreqString(freq)
%     sufs = ["Hz", "kHz", "MHz", "GHz"];
%     index = 1;
%     while freq > 1e3
%         freq = freq / 1e3;
%         index = index + 1;
%     end
%     freqString = sprintf("%.2f %s", freq, sufs(index));
% end

clc;
clear variables;
warning('off', 'all');

% Environment setup
[surfaces, envWidth, envHeight, envDepth] = setupEnvironment();

% Transmitter setup
Tx = [30, 20, 5]; % Example transmitter position
plotTransmitter(Tx);

% Parameters
txPower = 20; % Transmit power in dBm
reflection_coefficient = 0.6; % Reflection coefficient
freq = 60e9; % Frequency in Hz

% Generate rays and handle reflections
plotRays(Tx, surfaces, txPower, reflection_coefficient, freq);

% Create manual legend
createLegend();

% Add annotations for transmitter and environment settings
textStr = sprintf(['Plot Information:\nTx position: x = %.2f, y = %.2f, z = %.2f\n', ...
                   'TxPower = %.2f dBm\nReflection Coefficient = %.2f\nFrequency = %s'], ...
                   Tx(1), Tx(2), Tx(3), txPower, reflection_coefficient, getFreqString(freq));

annotation('textbox', [0.7, 0.1, 0.2, 0.1], ... % [x, y, width, height] in normalized figure units
           'String', textStr, ...              % The content of the textbox
           'FitBoxToText', 'on', ...           % Adjust box size to fit the text
           'EdgeColor', 'black', ...           % Border color
           'BackgroundColor', 'white', ...     % Background color
           'FontSize', 10);                    % Font size

% Adjust 3D view
a = -40;
e = 60;
view(a, e); % Set 3D view
title('3D Environment with Ray Tracing Up to Two Reflections');

hold off;

% Function to generate and reflect rays using all surfaces
function plotRays(Tx, surfaces, txPower, reflection_coefficient, freq)
    plotRaysWithReflections(Tx, surfaces, txPower, reflection_coefficient, freq);
end

