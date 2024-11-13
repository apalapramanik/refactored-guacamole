classdef Transmitter < handle
    properties
        Position % Position of the transmitter in 3D space
        Rays % Array of Ray objects
        Power
    end
    
    methods
        function obj = Transmitter(position, power)
            obj.Position = position;
            obj.Power = power;
            obj.Rays = Ray.empty(0, 1); % Initialize Rays as an empty array
        end
        

        function pr = PathLossLOS(obj, point, lambda, g_t, g_r)
            pr = 0;
            for i = 1:numel(obj.Rays)
                ray = obj.Rays(i);
                if ray.isPointOnRay(point)
                    d= sqrt(sum((point - ray.Position).^2));
                    pr = obj.Power * g_t * g_r * (lambda / (4 * pi * d)) ^ 2;
                end
            end
        end

        function randomPL(obj)
            n = 100;
            count = 0;
            points = 50 * rand(n, 3);
            newPoint = [25, 25, 5];
            points = [points; newPoint];
            gt = 1;
            gr = 1;
            lambda = 3e-1;
            for i = 1:n
                pr = obj.PathLossLOS(points(i), lambda, gt, gr);
                if pr ~= 0
                    fprintf("At point x = %d, y = %d, z = %d, power received = %d\n", points(i, 1), points(i, 2), points(i, 3), pr);
                    count = count + 1;
                end
            end

            fprintf("total number of successful points = %d\n", count);
        end
    

         % Example method to add a ray
        function obj = addRay(obj, ray)
            if isa(ray, 'Ray')
                obj.Rays(end + 1) = ray; % Append new ray to the array
                 %fprintf("adding ray: %s. Current num elements = %d\n", ray.toString(), numel(obj.Rays));
            else
                error('Input must be an instance of Ray class');
            end
        end
        
        function printRays(obj)
            n = numel(obj.Rays);
            for i = 1:n
                %fprintf("%s\n", obj.Rays(i).toString);
            end
            fprintf("total num rays = %d\n", numel(obj.Rays));
        end

        function plotTransmitter(obj)
            % Plot the transmitter's position
            plot3(obj.Position(1), obj.Position(2), obj.Position(3), 'ro', 'MarkerSize', 10, 'DisplayName', 'Transmitter');
            hold on;
            obj.plotRays();
        end
        
        function plotRays(obj)
            % Call each Ray's plot method
            n = numel(obj.Rays);
            for i = 1:n
                %fprintf("%s\n", obj.Rays(i).toString);
                obj.Rays(i).plotRay();
            end
        end
    end
end