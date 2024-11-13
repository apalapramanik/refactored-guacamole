classdef Floor < Wall
    methods
        function plotFloor(obj)
            fill3(obj.Vertices(:,1), obj.Vertices(:,2), obj.Vertices(:,3), [0.9, 0.9, 0.9]);
            hold on;
            fprintf("plotting floor\n");
        end
    end
end