classdef Ray < handle
    properties
        Position    % Starting position of the ray [x, y, z]
        Direction   % Direction vector [dx, dy, dz]
        Power       % Initial power of the ray
        Reflections %reflected rays
    end
    
    methods
        % Constructor to initialize ray properties
        function obj = Ray(position, direction, power)
            %fprintf("Num args = %d\n", nargin)
            if (nargin == 3)
                obj.Position = position;
                obj.Direction = direction;
                obj.Power = power;
            else 
                obj.Position = [0, 0, 0];
                obj.Direction = [0, 0, 0];
                obj.Power = 0;
            end
    
        end
    

        function plotRay(obj, length, color)
            n = norm(obj.Direction);
            if (n ~= 0)
                unit_direction = obj.Direction / norm(obj.Direction);
                endPoint = length * unit_direction;
                plot3([obj.Position(1), endPoint(1)], [obj.Position(2), endPoint(2)], [obj.Position(3), endPoint(3)], color);
                hold on;
            end
        end
        
        function reflectedRay = reflect(obj, normal)
            newDirection = obj.Direction - 2 * dot(obj.Direction, normal) * normal;
            reflectedRay = Ray(obj.Position, newDirection);
        end
        
        function str = toString(obj)
            str = sprintf("This is a ray. x = %d, y = %d, z = %d, direction = %d, %d, %d. Norm = %d", obj.Position(1), obj.Position(2), obj.Position(3), obj.Direction(1), obj.Direction(2), obj.Direction(3), norm(obj.Direction));
        end
        
    end
end