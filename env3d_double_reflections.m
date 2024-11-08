% Main function to set up the 3D environment and generate rays with up to two reflections
function createEnvironmentWithReflections()
    % Define the environment's dimensions
    envWidth = 50; % Width of the environment
    envHeight = 50; % Height of the environment
    envDepth = 50; % Depth of the environment

    % Initialize figure for 3D plotting
    figure;
    hold on;
    axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    xlim([0 envWidth]); ylim([0 envDepth]); zlim([0 envHeight]);

    % Create walls and store them as reflective surfaces
    surfaces = {};
    surfaces{end+1} = createWall([0 0 0], [envWidth 0 envHeight]); % Back wall
    surfaces{end+1} = createWall([0 envDepth 0], [envWidth envDepth envHeight]); % Front wall
    surfaces{end+1} = createWall([0 0 0], [0 envDepth envHeight]); % Left wall
    surfaces{end+1} = createWall([envWidth 0 0], [envWidth envDepth envHeight]); % Right wall
    surfaces{end+1} = createWall([0 0 envHeight], [envWidth 0 envHeight]); % Top wall
    surfaces{end+1} = createWall([0 envDepth envHeight], [envWidth envDepth envHeight]); % Top front wall

    % Create floor and add it as a reflective surface
    surfaces{end+1} = createFloor([0 0 0], [envWidth envDepth 0]); % Floor

    % Create obstacles and add their surfaces as reflective surfaces
    obstacleSurfaces1 = createObstacle([10 10 0], [5 5 3]); % Obstacle 1
    obstacleSurfaces2 = createObstacle([20 20 0], [4 4 4]); % Obstacle 2
    surfaces = [surfaces, obstacleSurfaces1{:}, obstacleSurfaces2{:}]; % Append surfaces of obstacles

    % Transmitter position in 3D
    Tx = [25, 25, 5]; % Example transmitter position
    plot3(Tx(1), Tx(2), Tx(3), 'ro', 'MarkerSize', 10, 'DisplayName', 'Transmitter');

    % Generate and reflect rays using all surfaces
    plotRaysWithReflections(Tx, surfaces);

    hold off;
    view(3); % Set 3D view
    title('3D Environment with Ray Tracing and Up to Two Reflections');
end

% Function to create a wall between two corners in 3D space and return its vertices
function vertices = createWall(startCorner, endCorner)
    vertices = [
        startCorner;
        endCorner(1), startCorner(2), startCorner(3);
        endCorner;
        startCorner(1), endCorner(2), endCorner(3)
    ];
    fill3(vertices(:, 1), vertices(:, 2), vertices(:, 3), [0.8, 0.8, 0.8]); % Gray color for walls
end

% Function to create a floor between two corners and return its vertices
function vertices = createFloor(startCorner, endCorner)
    vertices = [
        startCorner;
        endCorner(1), startCorner(2), startCorner(3);
        endCorner;
        startCorner(1), endCorner(2), endCorner(3)
    ];
    fill3(vertices(:, 1), vertices(:, 2), vertices(:, 3), [0.9, 0.9, 0.9]); % Light gray color for floor
end

% Function to create a rectangular obstacle and return its surfaces as a cell array of vertices
function surfaces = createObstacle(position, size)
    x = [0 1 1 0 0 1 1 0] * size(1) + position(1);
    y = [0 0 1 1 0 0 1 1] * size(2) + position(2);
    z = [0 0 0 0 1 1 1 1] * size(3) + position(3);

    vertices = [x', y', z'];
    faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8];
    surfaces = cell(6, 1);
    for i = 1:6
        surfaces{i} = vertices(faces(i, :), :);
        patch('Vertices', vertices, 'Faces', faces(i, :), 'FaceColor', [0.5, 0.5, 0.5]);
    end
end

% Function to plot rays and simulate up to two reflections off all surfaces
function plotRaysWithReflections(Tx, surfaces)
  

    numTheta = 12; % Number of steps for theta (horizontal angle)
    numPhi = 6; % Number of steps for phi (vertical angle)
    thetaValues = linspace(0, 2*pi, numTheta);
    phiValues = linspace(0, pi, numPhi);


    % Generate rays in an omnidirectional pattern
    for theta = thetaValues
        for phi = phiValues
            direction = [sin(phi) * cos(theta), sin(phi) * sin(theta), cos(phi)];

            % Track the ray's path and reflect it up to two times
            currentOrigin = Tx;
            currentDirection = direction;

            for reflection = 1:3 % Limit to 2 reflections
                [closestIntersection, normal] = findClosestIntersection(currentOrigin, currentDirection, surfaces);

                if ~isempty(closestIntersection)
                    % Plot the ray based on reflection number
                    if reflection == 1
                        plot3([currentOrigin(1), closestIntersection(1)], ...
                              [currentOrigin(2), closestIntersection(2)], ...
                              [currentOrigin(3), closestIntersection(3)], 'g-'); % Incident ray in green
                    elseif reflection == 2
                        plot3([currentOrigin(1), closestIntersection(1)], ...
                              [currentOrigin(2), closestIntersection(2)], ...
                              [currentOrigin(3), closestIntersection(3)], 'r-'); % First reflection in red
                    else
                        plot3([currentOrigin(1), closestIntersection(1)], ...
                              [currentOrigin(2), closestIntersection(2)], ...
                              [currentOrigin(3), closestIntersection(3)], 'b-'); % Second reflection in blue
                    end

                    % Calculate the reflected direction
                    currentDirection = reflectRay(currentDirection, normal);

                    % Update the origin for the next reflection
                    currentOrigin = closestIntersection;
                else
                    % No further intersections found; plot the remaining ray as a dotted line
                    endPoint = currentOrigin + currentDirection * 5; % Extend for visualization
                    plot3([currentOrigin(1), endPoint(1)], ...
                          [currentOrigin(2), endPoint(2)], ...
                          [currentOrigin(3), endPoint(3)], 'k--'); % Dotted line for unreflected ray
                    break;
                end
            end
        end
    end
end

% Function to find the closest intersection of a ray with any surface
function [closestIntersection, normal] = findClosestIntersection(origin, direction, surfaces)
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
