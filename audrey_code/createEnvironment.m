function createEnvironment()
    clc;
    clear variables;
    figure;
    axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    xlim([0 50]); ylim([0 50]); zlim([0 50]);

    % Initialize environment objects
    tx_power = 10;
    Tx = Transmitter([25, 25, 5], tx_power);
    
    surfaces = {
        Wall([0 50 0], [50 50 50]), ...
        Floor([0 0 0], [50 50 0]), Obstacle([10, 10, 0], [5, 5, 3])
    };
    
    for i = 1:numel(surfaces)
        surfaces{i}.plotWall();
    end

    % Ray plotting example
    theta = linspace(0, 2 * pi, 12);
    phi = linspace(0, pi, 6);

    for t = theta
        for p = phi
            dir = [sin(p) * cos(t), sin(p) * sin(t), cos(p)];
            [closestIntersection, normal, dist] = findClosestIntersection(Tx.Position, dir, surfaces);
            ray = Ray(Tx.Position, dir, tx_power, dist, 'g');
            Tx.addRay(ray);
            if ~isempty(closestIntersection)
                ray2 = ray.reflect(normal);
                Tx.addRay(ray2);
            end
        end
    end
    
    %Tx.printRays();
    Tx.plotTransmitter();
    Tx.randomPL();
    grid on;
    hold off;
    view(3);
    title('3D Environment with Ray Tracing');
end


function [closestIntersection, normal, dist] = findClosestIntersection(origin, direction, surfaces)
    closestIntersection = [];
    minDistance = inf;
    normal = [];
    dist = 10;

    % Check for intersections with each surface
    for i = 1:length(surfaces)
        intersection = rayPlaneIntersection(origin, direction, surfaces{i});
        if ~isempty(intersection)
            %fprintf("intersection found at %d, %d, %d\n", intersection(1), intersection(2), intersection(3));
            distance = norm(intersection - origin);
            dist = distance;
            if distance < minDistance
                minDistance = distance;
                closestIntersection = intersection;
                %disp(closestIntersection);
                normal = calculatePlaneNormal(surfaces{i});
            end
        end
    end
end

% Function to find the intersection of a ray and a plane
function intersection = rayPlaneIntersection(origin, direction, planeVertices)
    normal = calculatePlaneNormal(planeVertices);
    d = dot(normal, planeVertices.Vertices(1, :));
    denom = dot(normal, direction);

    if abs(denom) > 1e-6 % Check if the ray is not parallel
        t = (d - dot(normal, origin)) / denom;
        if t > 0 % Intersection is in the ray's direction
            intersection = origin + t * direction;

            % Check if the intersection point is within the plane's bounds
            if isPointInPolygon3D(intersection, planeVertices)
                return;
            end
        end
    end
    intersection = [];
end

function isInside = isPointInPolygon3D(point, polygonVertices)
    % Project the polygon and the point onto the plane defined by the polygon
    normal = calculatePlaneNormal(polygonVertices);
    d = -dot(normal, polygonVertices.Vertices(1, :));
    projectedPoint = point - (dot(normal, point) + d) * normal;
    %disp(projectedPoint);
    % Check if the projected point lies within the polygon bounds
    isInside = inpolygon(projectedPoint(1), projectedPoint(2), polygonVertices.Vertices(:, 1), polygonVertices.Vertices(:, 2));
    
    % Ensure 3D intersection consistency
    if isInside
        boundsMin = min(polygonVertices.Vertices);
        boundsMax = max(polygonVertices.Vertices);
        isInside = all(point >= boundsMin) && all(point <= boundsMax);
    end
end

% Function to calculate the normal of a plane given its vertices
function normal = calculatePlaneNormal(planeVertices)
    normal = planeVertices.getNormal();% Normalize the normal vector
end