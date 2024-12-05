
function plotRaysWithReflections(Tx, surfaces, txPower, reflection_coefficient, freq, pathLossExponent, shadowingStdDev)
   
    % Constants
    maxReflections = 3; % Maximum number of reflections
    powerThreshold = -100; % Minimum power in dBm to continue tracing rays
    stepSize = 0.1; % Increment for tracing ray segments
    c = 3e8; % Speed of light in m/s
    
    % Frequency and wavelength
    lambda = c / freq;

    % Angular ranges for rays
    numTheta = 6; % Number of azimuth angles
    numPhi = 3; % Number of elevation angles
    thetaValues = linspace(pi/4, 3*pi/4, numTheta); % Azimuth angles
    phiValues = linspace(pi/2 - 0.1, pi/2 + 0.1, numPhi); % Elevation angles

    % Loop through all angular combinations
    for theta = thetaValues
        for phi = phiValues
            % Ray direction vector
            direction = [sin(phi) * cos(theta), sin(phi) * sin(theta), cos(phi)];
            currentOrigin = Tx; % Start ray at transmitter
            currentDirection = direction; % Initial ray direction
            totalDistance = 0; % Accumulated distance
            txPower = txPower; % Initial transmit power
            
            % Process up to maxReflections
            for reflection = 1:maxReflections
                [closestIntersection, normal, distance] = findClosestIntersection(currentOrigin, currentDirection, surfaces);

                if ~isempty(closestIntersection)
                    % Plot the ray segment
                    plotRaySegment(currentOrigin, closestIntersection, txPower, freq, stepSize, totalDistance, pathLossExponent, shadowingStdDev, theta, phi);
                    
                    % Update ray properties for the next reflection
                    currentOrigin = closestIntersection;
                    currentDirection = reflectRay(currentDirection, normal);
                    totalDistance = totalDistance + distance;

                    % Update the power after reflection
                    txPower = txPower - 10 * log10(reflection_coefficient);
                    
                    % Terminate ray if power drops below threshold
                    if txPower < powerThreshold
                        break;
                    end
                else
                    % No intersection; plot remaining ray
                    plotRaySegment(currentOrigin, currentOrigin + 5 * currentDirection, txPower, freq, stepSize, totalDistance,pathLossExponent, shadowingStdDev, theta, phi);
                    break;
                end
            end
        end
    end
end

% Function to plot a ray segment with path loss-based coloring
function plotRaySegment(startPoint, endPoint, txPower, freq, stepSize, totalDistance, pathLossExponent, shadowingStdDev, theta, phi)
    pathLossExponent = 3; % Path loss exponent (n)
    shadowingStdDev = 8; % Log-normal shadowing standard deviation (\sigma)
    c = 3e8; % Speed of light in m/s
    lambda = c / freq; % Wavelength
    
    % Incrementally plot the ray segment
    currentPoint = startPoint;
    direction = (endPoint - startPoint) / norm(endPoint - startPoint);
    segmentLength = norm(endPoint - startPoint);
    
    for d = 0:stepSize:segmentLength
        % Update distance and calculate received power
        totalDistance = totalDistance + stepSize;
        pathLoss = 20 * log10(totalDistance) + 10 * pathLossExponent * log10(totalDistance / 1) + ...
           normrnd(0, shadowingStdDev); % Log-normal shadowing
        pr = txPower - pathLoss ;

        % Map power to a color
        color = powerToColor(pr);

        % Plot the ray segment
        nextPoint = currentPoint + stepSize * direction;
        plot3([currentPoint(1), nextPoint(1)], [currentPoint(2), nextPoint(2)], [currentPoint(3), nextPoint(3)], ...
            'Color', color, 'LineWidth', 1.5);
        currentPoint = nextPoint;
    end
end

% Function to find the closest intersection of a ray with any surface
function [closestIntersection, normal, dist] = findClosestIntersection(origin, direction, surfaces)
    closestIntersection = [];
    minDistance = inf;
    normal = [];
    dist = 0;

    for i = 1:length(surfaces)
        intersection = rayPlaneIntersection(origin, direction, surfaces{i});
        if ~isempty(intersection)
            distance = norm(intersection - origin);
            if distance < minDistance
                minDistance = distance;
                closestIntersection = intersection;
                normal = calculatePlaneNormal(surfaces{i});
                dist = minDistance;
            end
        end
    end
end


function color = powerToColor(pr)
    % Define the range of power levels (in dBm)
    minPr = -100; % Minimum power for the gradient
    maxPr = 0;   % Maximum power for the gradient

    % Normalize power level to [0, 1] range
    normalizedPr = (pr - minPr) / (maxPr - minPr);
    normalizedPr = max(0, min(1, normalizedPr)); % Clamp values to [0, 1]

    % Use the jet colormap for smooth gradient
    colormapData = BuGn(256); % Generate a colormap with 256 colors
    colorIndex = round(normalizedPr * 255) + 1; % Map normalized power to colormap index
    color = colormapData(colorIndex, :); % Retrieve the RGB triplet for the color
end

% Function to reflect a ray based on a surface normal
function reflectedRay = reflectRay(incidentRay, normal)
    reflectedRay = incidentRay - 2 * dot(incidentRay, normal) * normal;
    reflectedRay = reflectedRay / norm(reflectedRay); % Normalize the reflected ray
end

% Function to find the intersection of a ray with a plane
function intersection = rayPlaneIntersection(origin, direction, planeVertices)
    normal = calculatePlaneNormal(planeVertices);
    d = dot(normal, planeVertices(1, :));
    denom = dot(normal, direction);

    if abs(denom) > 1e-6 % Ray is not parallel to the plane
        t = (d - dot(normal, origin)) / denom;
        if t > 0 % Intersection is in the forward direction
            intersection = origin + t * direction;
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

% Function to check if a point lies within a 3D polygon
function isInside = isPointInPolygon3D(point, polygonVertices)
    % Project the polygon and point onto the plane
    normal = calculatePlaneNormal(polygonVertices);
    d = -dot(normal, polygonVertices(1, :));
    projectedPoint = point - (dot(normal, point) + d) * normal;

    % Check bounds in the primary plane
    isInside = inpolygon(projectedPoint(1), projectedPoint(2), polygonVertices(:, 1), polygonVertices(:, 2));
end


function gain = antennaGain(theta, phi)
    % Example: Directional gain pattern
    gainMax = 10; % Maximum gain in dBi
    gain = gainMax * sinc(2 * theta / pi) * sinc(2 * phi / pi);
end


