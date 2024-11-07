classdef transceiver_model
    properties
        Position      % Position of the transmitter [x, y, z]
        Power_dBm     % Transmit power in dBm
        Gain_dB       % Antenna gain in dB
        Frequency_GHz % Frequency in GHz
    end
    
    methods
        % Constructor
        function obj = transceiver_model(position, power_dBm, gain_dB, frequency_GHz)
            obj.Position = position;
            obj.Power_dBm = power_dBm;
            obj.Gain_dB = gain_dB;
            obj.Frequency_GHz = frequency_GHz;
        end
        
        % Generate rays in multiple directions
        function rays = generateRays(obj, numRays)
            rays(numRays) = Ray([], [], []); % Preallocate array of Ray objects
            for i = 1:numRays
                % Randomize direction in 3D space (spherical coordinates)
                azimuth = 2 * pi * rand;          % Azimuth angle [0, 2*pi]
                elevation = pi * (rand - 0.5);    % Elevation angle [-pi/2, pi/2]
                
                % Convert spherical to Cartesian direction vector
                dx = cos(elevation) * cos(azimuth);
                dy = cos(elevation) * sin(azimuth);
                dz = sin(elevation);
                
                % Initial power in watts
                power_W = 10^((obj.Power_dBm + obj.Gain_dB - 30) / 10);
                
                x = obj.Position(1);
                y = obj.Position(2);
                z = obj.Position(3);
                % Create Ray object with initial position, direction, and power
                rays(i) = Ray([x, y, z], [dx, dy, dz] , power_W);
                %rays(i) = Ray(x, y, z);
            end
        end
    end
end