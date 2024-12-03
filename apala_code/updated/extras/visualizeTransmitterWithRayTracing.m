function visualizeTransmitterWithRayTracing()
    % Define substrate properties for the patch antenna
    substrate = dielectric('FR4');
    substrate.Thickness = 0.2e-3; % Substrate thickness optimized for 60 GHz

    % Define patch antenna dimensions
    patch = patchMicrostrip('Length', 4.8e-3, ...  % Length for 60 GHz
                            'Width', 3.2e-3, ...   % Width for 60 GHz
                            'Substrate', substrate, ...
                            'GroundPlaneLength', 6e-3, ...
                            'GroundPlaneWidth', 6e-3);

    % Display the 3D radiation pattern
    figure;
    pattern(patch, 60e9);
    title('Radiation Pattern of the Transmitter at 60 GHz');
end
