% function plotAntennaPattern(Tx)
%     % Define the antenna pattern parameters
%     azimuth_range = linspace(pi/4, 3*pi/4, 100); % Azimuth range (-45° to 45°)
%     elevation_range = linspace(0, pi/2, 50); % Elevation range (0° to 90°)
%     [Theta, Phi] = meshgrid(azimuth_range, elevation_range);
% 
%     % Example: Directional antenna gain (cosine pattern)
%     Gain = abs(cos(Phi)); % Adjust pattern as needed for specific antennas
% 
%     % Convert spherical to Cartesian coordinates
%     r = Gain * 10; % Scale factor for visualization
%     X = r .* sin(Phi) .* cos(Theta) + Tx(1);
%     Y = r .* sin(Phi) .* sin(Theta) + Tx(2);
%     Z = r .* cos(Phi) + Tx(3);
% 
%     % Plot the antenna pattern
%     surf(X, Y, Z, Gain, 'EdgeColor', 'none', 'FaceAlpha', 0.5); % Semi-transparent
%     colormap('jet'); % Apply colormap for gain visualization
%     colorbar; % Add colorbar to show gain levels
% end

% function plotAntennaPattern(Tx)
%     % Define the antenna pattern parameters
%     azimuth_range = linspace(pi/4, 3*pi/4, 100); % Azimuth range (45° to 135°)
%     elevation = pi/2; % Fixed elevation for horizontal pattern
% 
%     % Example: Directional antenna gain (cosine pattern)
%     Gain = abs(cos(azimuth_range - pi/2)); % Symmetric gain around 90° (horizontal)
% 
%     % Convert spherical to Cartesian coordinates
%     r = Gain' * 10; % Scale factor for visualization
%     [Azimuth, R] = meshgrid(azimuth_range, r); % Create grid for azimuth and radius
%     X = R .* cos(Azimuth) + Tx(1); % X-coordinates
%     Y = R .* sin(Azimuth) + Tx(2); % Y-coordinates
%     Z = ones(size(X)) * Tx(3); % Fixed Z-coordinate for horizontal pattern
% 
%     % Plot the antenna pattern
%     surf(X, Y, Z, R, 'EdgeColor', 'none', 'FaceAlpha', 0.5); % Semi-transparent
%     colormap('jet'); % Apply colormap for gain visualization
%     colorbar; % Add colorbar to show gain levels
% end

function plotAntennaPattern(Tx)
    % Define the antenna pattern parameters
    azimuth_range = linspace(pi/4, 3*pi/4, 100); % Azimuth range (45° to 135°)
    elevation_range = linspace(pi/2 - 0.1, pi/2 + 0.1, 50); % Narrow elevation range
    [Theta, Phi] = meshgrid(azimuth_range, elevation_range); % Create a meshgrid

    % Example: Directional antenna gain (cosine pattern)
    Gain = abs(cos(Phi - pi/2)) .* abs(cos(Theta - pi/2)); % Combined gain

    % Convert spherical to Cartesian coordinates
    r = Gain * 10; % Scale factor for visualization
    X = r .* sin(Phi) .* cos(Theta) + Tx(1); % X-coordinates
    Y = r .* sin(Phi) .* sin(Theta) + Tx(2); % Y-coordinates
    Z = r .* cos(Phi) + Tx(3); % Z-coordinates

    % Plot the antenna pattern
    surf(X, Y, Z, Gain, 'EdgeColor', 'none', 'FaceAlpha', 0.5); % Semi-transparent
    colormap('jet'); % Apply colormap for gain visualization
    colorbar; % Add colorbar to show gain levels
end


