


function plotRaysWithReflections(Tx, surfaces, ant)
    numTheta = 12; % Steps for theta (horizontal angle)
    numPhi = 6; % Steps for phi (vertical angle)
    thetaValues = linspace(0, 2 * pi, numTheta);
    phiValues = linspace(0, pi, numPhi);

    % Generate rays in a pattern based on antenna's radiation pattern
    for theta = thetaValues
        for phi = phiValues
            direction = [sin(phi) * cos(theta), sin(phi) * sin(theta), cos(phi)];
            currentOrigin = Tx;
            currentDirection = direction;
            txPower = 20; % Transmitter power in dBm
            length = 0.1;
            dist_from_tx = 0;
            dist_from_origin = length; % Incremental step size

            for reflection = 1:3 % Limit to 2 reflections
                [closestIntersection, normal, distance] = findClosestIntersection(currentOrigin, currentDirection, surfaces);
                if ~isempty(closestIntersection)
                    % Plot the ray based on reflection number
                    startPoint = currentOrigin;
                    endPoint = currentOrigin + length * currentDirection;
                    while dist_from_origin <= distance
                        [pr, color] = PathLossWithAntennaGain(dist_from_tx, txPower, ant, theta, phi);
                        plot3([startPoint(1), endPoint(1)], ...
                              [startPoint(2), endPoint(2)], ...
                              [startPoint(3), endPoint(3)], color);
                        startPoint = startPoint + length * currentDirection;
                        endPoint = endPoint + length * currentDirection;
                        dist_from_origin = dist_from_origin + length;
                        dist_from_tx = dist_from_tx + length;
                    end
                    % Calculate the reflected direction
                    currentDirection = reflectRay(currentDirection, normal);

                    % Update the origin for the next reflection
                    currentOrigin = closestIntersection;
                    dist_from_origin = length;
                else
                    % No further intersections found; plot the remaining ray as a dotted line
                    startPoint = currentOrigin;
                    length = 5;
                    endPoint = currentOrigin + length * currentDirection;
                    dist_from_tx = dist_from_tx + length;
                    [pr, color] = PathLossWithAntennaGain(dist_from_tx, txPower, ant, theta, phi);
                    colorString = sprintf('%s--', color);
                    plot3([startPoint(1), endPoint(1)], ...
                          [startPoint(2), endPoint(2)], ...
                          [startPoint(3), endPoint(3)], colorString); % Incident ray in dotted line
                    break;
                end
            end
        end
    end
end

% Function to find the closest intersection of a ray with any surface
function [closestIntersection, normal, minDistance] = findClosestIntersection(origin, direction, surfaces)
    closestIntersection = [];
    minDistance = inf;
    normal = [];

    % Check for intersections with each surface
    for i = 1:length(surfaces)
        intersection = rayPlaneIntersection(origin, direction, surfaces{i});
        if ~isempty(intersection)
            distance = norm(intersection - origin);
            if distance < minDistance
                minDistance = distance;
                closestIntersection = intersection;
                normal = calculatePlaneNormal(surfaces{i});
            end
        end
    end
end


% % Function to find the closest intersection of a ray with any surface
% function [closestIntersection, normal] = findClosestIntersection(origin, direction, surfaces)
%     closestIntersection = [];
%     minDistance = inf;
%     normal = [];
% 
%     % Check for intersections with each surface
%     for i = 1:length(surfaces)
%         intersection = rayPlaneIntersection(origin, direction, surfaces{i});
%         if ~isempty(intersection)
%             distance = norm(intersection - origin);
%             if distance < minDistance
%                 minDistance = distance;
%                 closestIntersection = intersection;
%                 normal = calculatePlaneNormal(surfaces{i});
%             end
%         end
%     end
% end

% Function to find the intersection of a ray and a plane
function intersection = rayPlaneIntersection(origin, direction, planeVertices)
    normal = calculatePlaneNormal(planeVertices);
    d = dot(normal, planeVertices(1, :));
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

% Function to calculate the normal of a plane given its vertices
function normal = calculatePlaneNormal(planeVertices)
    v1 = planeVertices(2, :) - planeVertices(1, :);
    v2 = planeVertices(3, :) - planeVertices(1, :);
    normal = cross(v1, v2);
    normal = normal / norm(normal); % Normalize the normal vector
end

% Function to reflect a ray based on a surface normal
function reflectedRay = reflectRay(incidentRay, normal)
    reflectedRay = incidentRay - 2 * dot(incidentRay, normal) * normal;
    reflectedRay = reflectedRay / norm(reflectedRay); % Normalize the reflected ray
end

% Function to check if a point lies within a 3D polygon
function isInside = isPointInPolygon3D(point, polygonVertices)
    % Project the polygon and the point onto the plane defined by the polygon
    normal = calculatePlaneNormal(polygonVertices);
    d = -dot(normal, polygonVertices(1, :));
    projectedPoint = point - (dot(normal, point) + d) * normal;

    % Check if the projected point lies within the polygon bounds
    isInside = inpolygon(projectedPoint(1), projectedPoint(2), polygonVertices(:, 1), polygonVertices(:, 2));
    
    % Ensure 3D intersection consistency
    if isInside
        boundsMin = min(polygonVertices);
        boundsMax = max(polygonVertices);
        isInside = all(point >= boundsMin) && all(point <= boundsMax);
    end
end