function create60GHzHPolarizedAntennaArray()
    % Define substrate properties
    substrate = dielectric('FR4');
    substrate.Thickness = 0.2e-3; % Substrate thickness optimized for 60 GHz

    % Define patch dimensions with valid feed placement
    patchLength = 6e-3; % Increase patch length
    patchWidth = 4e-3;  % Increase patch width
    patch = patchMicrostrip('Length', patchLength, ...
                            'Width', patchWidth, ...
                            'Substrate', substrate, ...
                            'GroundPlaneLength', 8e-3, ...
                            'GroundPlaneWidth', 8e-3);

    % Set feed offset explicitly within the valid range
    feedX = patchWidth / 4; % Quarter of the width
    if feedX < -0.003
        error('FeedOffset out of valid range. Adjust patchWidth.');
    end
    patch.FeedOffset = [feedX, 0]; % Valid feed offset for horizontal polarization

    % Create a rectangular array with 8 rows and 2 columns
    antArray = rectangularArray('Element', patch, ...
                                'RowSpacing', 0.5 * (3e8 / 60e9), ... % Lambda/2 spacing
                                'ColumnSpacing', 0.5 * (3e8 / 60e9), ...
                                'Size', [8, 2]); % 8 rows and 2 columns

    % Visualize the antenna array structure
    figure;
    show(antArray);
    title('3D Structure of 60 GHz H-Polarized Antenna Array');

    % Plot the radiation pattern
    figure;
    pattern(antArray, 60e9);
    title('Radiation Pattern of H-Polarized Antenna Array at 60 GHz');

    % Validate beamwidths
    [azimuthBW, elevationBW] = calculateBeamwidth(antArray, 60e9);
    fprintf('3dB Beamwidths: Azimuth = %.2f°, Elevation = %.2f°\n', azimuthBW, elevationBW);
end

function [azimuthBW, elevationBW] = calculateBeamwidth(antArray, freq)
    % Extract the 3dB beamwidths from the antenna radiation pattern
    azimuthPattern = patternAzimuth(antArray, freq, 0);
    elevationPattern = patternElevation(antArray, freq, 0);
    
    % Find beamwidth at -3dB points
    azimuthBW = findBeamwidth(azimuthPattern);
    elevationBW = findBeamwidth(elevationPattern);
end

function bw = findBeamwidth(patternData)
    % Find the angular range where the pattern is within -3dB of the peak
    peakGain = max(patternData);
    threshold = peakGain - 3;
    indices = find(patternData >= threshold);
    bw = abs(indices(end) - indices(1)); % Angular range as the beamwidth
end
