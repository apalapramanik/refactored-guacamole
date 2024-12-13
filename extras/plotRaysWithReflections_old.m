

% Function to plot rays and simulate up to two reflections off all surfaces
function plotRaysWithReflections(Tx, surfaces, txStartPower, reflection_coefficient, freq)
  
    % numTheta = 12; % Number of steps for theta (horizontal angle)
    % numPhi = 6; % Number of steps for phi (vertical angle)
    % thetaValues = linspace(0, 2*pi, numTheta);
    % phiValues = linspace(0, pi, numPhi);

    % Define angular ranges for H-polarized antenna
    numTheta = 6; % Number of steps for azimuth angle
    numPhi = 3;    % Number of steps for elevation angle
    thetaValues = linspace(pi/4, 3*pi/4, numTheta); % Azimuth: -45° to +45°
    phiValues = linspace(pi/2 - 0.1, pi/2 + 0.1, numPhi); % Narrow band near horizontal plane
    
    % Generate rays in an omnidirectional pattern
    for theta = thetaValues
        for phi = phiValues
            direction = [sin(phi) * cos(theta), sin(phi) * sin(theta), cos(phi)];

            % Track the ray's path and reflect it up to two times
            currentOrigin = Tx;
            currentDirection = direction;
            length = 1;
            dist = length;
            txPower = txStartPower;

            for reflection = 1:3 % Limit to 2 reflections
                [closestIntersection, normal, distance] = findClosestIntersection(currentOrigin, currentDirection, surfaces);
                
                if ~isempty(closestIntersection)
                    % Plot the ray based on reflection number
                        startPoint = currentOrigin;
                        endPoint = currentOrigin + length * currentDirection;
                        while dist <= distance 
                            [pr, color] = PathLossLOS(dist, txPower, freq);
                           plot3([startPoint(1), endPoint(1)], ...
                                [startPoint(2), endPoint(2)], ...
                                [startPoint(3), endPoint(3)], color, 'LineWidth', 1.5);
                            startPoint = startPoint + length * currentDirection;
                            endPoint = endPoint + length * currentDirection;
                            dist = dist + length;
                        end
                    % Calculate the reflected direction
                    currentDirection = reflectRay(currentDirection, normal);

                    % Update the origin for the next reflection
                    currentOrigin = closestIntersection;
                    dist = length;
                    txPower = pr + 10 * log10(reflection_coefficient);
                else
                    % No further intersections found; plot the remaining ray as a dotted line
                        startPoint = currentOrigin;
                        length = 5;
                        endPoint = currentOrigin + length * currentDirection;
     

                             dist= dist + length;
                             [pr, color] = PathLossLOS(dist, txPower, freq); % Get the gradient color (RGB triplet)

                            
                                                    
                             % Plot the line segment with the dotted style and set LineWidth to 2
                             plot3([startPoint(1), endPoint(1)], ...
                                  [startPoint(2), endPoint(2)], ...
                                  [startPoint(3), endPoint(3)], '--', 'Color', color, 'LineWidth', 1.5); % Dotted line with correct color and width

                          
                   break;
                end
            end
        end
    end
end

% Function to find the closest intersection of a ray with any surface
function [closestIntersection, normal, dist] = findClosestIntersection(origin, direction, surfaces)
    closestIntersection = [];
    minDistance = inf;
    normal = [];
    dist = 20; %default value for distance
    % Check for intersections with each surface
    for i = 1:length(surfaces)
        intersection = rayPlaneIntersection(origin, direction, surfaces{i});
        if ~isempty(intersection)
            distance = norm(intersection - origin);
            if distance < minDistance
                minDistance = distance;
                dist = minDistance;
                closestIntersection = intersection;
                normal = calculatePlaneNormal(surfaces{i});
            end
        end
    end
end

function pointString = toString(point)
    pointString = sprintf("x = %.2f, y = %.2f, z = %.2f", point(1), point(2), point(3));
end

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
