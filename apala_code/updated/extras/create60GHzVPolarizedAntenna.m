
function ant = create60GHzHPolarizedAntenna()
    % Define the base patch antenna for 60 GHz
    ant = design(patchMicrostrip, 60e9);
    
    % Modify the feed location for horizontal polarization
    ant.FeedOffset = [ant.Length / 4, 0]; % Place feed along the horizontal axis

    % Display antenna structure
    figure;
    show(ant);
    title('3D Structure of the 60 GHz Patch Antenna (H-Polarized)');
    
    % Display antenna radiation pattern
    figure;
    pattern(ant, 60e9);
    title('Radiation Pattern of H-Polarized Antenna at 60 GHz');
    
    % Display 2D radiation pattern in azimuth plane
    figure;
    patternAzimuth(ant, 60e9, 0); % Azimuth pattern at elevation = 0 degrees
    title('Azimuth Radiation Pattern at 60 GHz (Elevation = 0°)');
    
    % Display 2D radiation pattern in elevation plane
    figure;
    patternElevation(ant, 60e9, 0); % Elevation pattern at azimuth = 0 degrees
    title('Elevation Radiation Pattern at 60 GHz (Azimuth = 0°)');
    
    % Display the current and charge distribution on the antenna surface
    figure;
    current(ant, 60e9);
    title('Current Distribution on 60 GHz Patch Antenna Surface (H-Polarized)');
    
    figure;
    charge(ant, 60e9);
    title('Charge Distribution on 60 GHz Patch Antenna Surface (H-Polarized)');
end
