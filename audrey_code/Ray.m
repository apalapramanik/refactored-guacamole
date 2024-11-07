classdef Ray
    properties
        Position    % Starting position of the ray [x, y, z]
        Direction   % Direction vector [dx, dy, dz]
        Power       % Initial power of the ray
    end
    
    methods
        % Constructor to initialize ray properties
        function obj = Ray(position, direction, power)
            %fprintf("Num args = %d\n", nargin)
            if (nargin > 0)
                obj.Position = position;
                obj.Direction = direction;
                obj.Power = power;
            else 
                obj.Position = [0, 0, 0];
                obj.Direction = [0, 0, 0];
                obj.Power = 0;
            end
    
        end
    end
end