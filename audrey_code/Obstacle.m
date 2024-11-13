classdef Obstacle 
    properties
        Surfaces
        Vertices
    end
    
    methods
        function obj = Obstacle(position, size)
            x = [0 1 1 0 0 1 1 0] * size(1) + position(1);
            y = [0 0 1 1 0 0 1 1] * size(2) + position(2);
            z = [0 0 0 0 1 1 1 1] * size(3) + position(3);
            obj.Vertices = [x', y', z'];
            faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8];
            
            obj.Surfaces = cell(6, 1);
            for i = 1:6
                obj.Surfaces{i} = obj.Vertices(faces(i, :), :);
            end
        end
        
        function plotWall(obj)
            for i = 1:length(obj.Surfaces)
                patch('Vertices', obj.Surfaces{i}, 'Faces', 1:4, 'FaceColor', [0.5, 0.5, 0.5]);
                hold on;
            end
            fprintf("plotting obstacle\n");
        end

        function normal = getNormal(obj)
            v1 = obj.Vertices(2, :) - obj.Vertices(1, :);
            v2 = obj.Vertices(3, :) - obj.Vertices(1, :);
            normal = cross(v1, v2);
            normal = normal / norm(normal);
        end
    end
end