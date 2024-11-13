classdef Ray < handle
    properties
        Position    % Starting position of the ray [x, y, z]
        Direction   % Direction vector [dx, dy, dz]
        Power       % Initial power of the ray
        Length
        Color
    end
    
    methods
        % Constructor to initialize ray properties
        function obj = Ray(position, direction, power, length, color)
            %fprintf("Num args = %d\n", nargin)
            if (nargin > 0)
                obj.Position = position;
                obj.Direction = direction;
                obj.Power = power;
                obj.Length = length;
                obj.Color = color;
            else 
                obj.Position = [0, 0, 0];
                obj.Direction = [0, 0, 0];
                obj.Power = 0;
                obj.Length = 0;
                obj.Color = 'k';
            end
    
        end
        
        function isOnRay = isPointOnRay(obj, point)
            % Vector from start to the point
            toPoint = point - obj.Position;
            
            % Check if 'toPoint' is parallel to 'direction' by computing
            % the cross product. If it's zero (or near zero), they are parallel.
            crossProd = cross(obj.Direction, toPoint);
            if norm(crossProd) > 1e-10  % Tolerance for floating-point comparison
                isOnRay = false;
                return;
            end
            
            % Check if the point lies within the ray's length
            t = dot(toPoint, obj.Direction); % Projection along direction
            if t >= 0 && t <= obj.Length
                isOnRay = true;
            else
                isOnRay = false;
            end
        end

        function plotRay(obj)
             n = norm(obj.Direction);
            if (n ~= 0)
                unit_direction = obj.Direction / norm(obj.Direction);
                endPoint = obj.Length * unit_direction;
                %fprintf("start x = %f, y = %f, z = %f, end x = %f, y = %f, z = %f\n", obj.Position(1), obj.Position(2), obj.Position(3), endPoint(1), endPoint(2), endPoint(3));
             
                plot3([obj.Position(1), endPoint(1)], [obj.Position(2), endPoint(2)], [obj.Position(3), endPoint(3)], obj.Color);
                hold on;
            end
        end
        
        function reflectedRay = reflect(obj, normal)
            newDirection = obj.Direction - 2 * dot(obj.Direction, normal) * normal;
            unit_direction = obj.Direction / norm(obj.Direction);
            endPoint = obj.Length * unit_direction;
            reflectedRay = Ray(endPoint, newDirection, obj.Power, 10, 'r');
        end
        
        function str = toString(obj)
            str = sprintf("This is a ray. x = %d, y = %d, z = %d, direction = %d, %d, %d. Norm = %d", obj.Position(1), obj.Position(2), obj.Position(3), obj.Direction(1), obj.Direction(2), obj.Direction(3), norm(obj.Direction));
        end
        
    end
end