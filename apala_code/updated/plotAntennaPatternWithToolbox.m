function plotAntennaPatternWithToolbox(Tx)
    % Define azimuth and elevation ranges
    azimuth_range = 45:135; % Azimuth from 45° to 135°
    elevation_range = rad2deg(pi/2 - 0.1):rad2deg(pi/2 + 0.1); % Narrow elevation range

    % Create a phased.CustomAntennaElement for a custom directional pattern
    antenna = phased.CustomAntennaElement( ...
        'FrequencyRange', [59e9 61e9], ... % Frequency range in Hz
        'AzimuthAngles', azimuth_range, ...
        'ElevationAngles', elevation_range, ...
        'MagnitudePattern', generatePattern(azimuth_range, elevation_range));

    % Visualize the antenna pattern
    figure;
    pattern(antenna, 60e9, azimuth_range, elevation_range, ...
        'Type', 'directivity', 'CoordinateSystem', 'rectangular', ...
        'Parent', gca);

    % Overlay the antenna pattern at Tx
    hold on;
    plotAntennaLobe(Tx, azimuth_range, elevation_range);
end

function gain = generatePattern(azimuthAngles, elevationAngles)
    % Define a simple cosine-based pattern
    [Az, El] = meshgrid(azimuthAngles, elevationAngles);
    gain = abs(cosd(Az - 90)) .* abs(cosd(El)); % Example directional pattern
end

function plotAntennaLobe(Tx, azimuth_range, elevation_range)
    % Convert spherical to Cartesian coordinates for a lobe visualization
    [Azimuth, Elevation] = meshgrid(deg2rad(azimuth_range), deg2rad(elevation_range));
    r = 10; % Scale factor
    X = r .* sin(Elevation) .* cos(Azimuth) + Tx(1);
    Y = r .* sin(Elevation) .* sin(Azimuth) + Tx(2);
    Z = r .* cos(Elevation) + Tx(3);

    % Plot the antenna lobe
    surf(X, Y, Z, 'EdgeColor', 'none', 'FaceAlpha', 0.6);
    colormap('jet');
    colorbar;
end
