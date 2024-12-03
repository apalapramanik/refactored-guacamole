function ant = create60GHzHPolarizedAntenna()
    % Define substrate properties
    substrate = dielectric('FR4');
    substrate.Thickness = 0.2e-3; % Substrate thickness optimized for 60 GHz

    % Define patch dimensions for 60 GHz
    patchLength = 4.8e-3; % Length of the patch
    patchWidth = 3.2e-3;  % Width of the patch
    groundPlaneSize = 6e-3;

    % Create the patch antenna
    ant = patchMicrostrip('Substrate', substrate, ...
                          'Length', patchLength, ...
                          'Width', patchWidth, ...
                          'GroundPlaneLength', groundPlaneSize, ...
                          'GroundPlaneWidth', groundPlaneSize);

    % Calculate the valid feed offset range and set the feed offset
    minFeedOffset = -patchWidth / 2 + 1e-6; % Avoid lower boundary violation
    maxFeedOffset = patchWidth / 2 - 1e-6; % Avoid upper boundary violation
    feedX = (minFeedOffset + maxFeedOffset) / 2; % Center the feed offset
    ant.FeedOffset = [feedX, 0]; % Valid feed offset for horizontal polarization

    % Rotate the antenna for vertical placement
    ant.Rotation = [90, 0, 0]; % Rotate 90° around the x-axis for vertical alignment

    % Display antenna structure
    figure;
    show(ant);
    title('3D Structure of the 60 GHz Patch Antenna (H-Polarized, Vertically Placed)');
    
    % Display 3D radiation pattern
    figure;
    pattern(ant, 60e9);
    title('3D Radiation Pattern of H-Polarized Antenna at 60 GHz');
    
    % Display 2D azimuth pattern
    figure;
    patternAzimuth(ant, 60e9, 0);
    title('Azimuth Radiation Pattern at 60 GHz (Elevation = 0°)');
    
    % Display 2D elevation pattern
    figure;
    patternElevation(ant, 60e9, 0);
    title('Elevation Radiation Pattern at 60 GHz (Azimuth = 0°)');
    
    % Display current distribution on the antenna
    figure;
    current(ant, 60e9);
    title('Current Distribution on the 60 GHz Patch Antenna Surface (H-Polarized)');
    
    % Display charge distribution on the antenna
    figure;
    charge(ant, 60e9);
    title('Charge Distribution on the 60 GHz Patch Antenna Surface (H-Polarized)');
end
