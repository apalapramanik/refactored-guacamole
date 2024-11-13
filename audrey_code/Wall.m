classdef Wall
    properties
        Vertices
    end
    
    methods
        function obj = Wall(startCorner, endCorner)
            obj.Vertices = [
                startCorner;
                endCorner(1), startCorner(2), startCorner(3);
                endCorner;
                startCorner(1), endCorner(2), endCorner(3)
            ];
        end
        
        function plotWall(obj)
            fill3(obj.Vertices(:,1), obj.Vertices(:,2), obj.Vertices(:,3), [0.8, 0.8, 0.8]);
            hold on;
            fprintf("plotting wall\n");
        end
        
        
        function normal = getNormal(obj)
            v1 = obj.Vertices(2, :) - obj.Vertices(1, :);
            v2 = obj.Vertices(3, :) - obj.Vertices(1, :);
            normal = cross(v1, v2);
            normal = normal / norm(normal);
        end
    end
end