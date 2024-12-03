% Define Transmitter, Receiver, and Surface(s)
Tx = [6, 4];               % Transmitter position
Rx = [7, 1];               % Receiver position

surface1 = [1, 0; 5, 12];  % Surface defined by two points (x1, y1) and (x2, y2)

% Create a figure for plotting
figure;
hold on;
plot(Tx(1), Tx(2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Transmitter');
plot(Rx(1), Rx(2), 'bo', 'MarkerSize', 8, 'DisplayName', 'Receiver');
plot(surface1(:,1), surface1(:,2), 'k-', 'LineWidth', 2, 'DisplayName', 'Surface 1');
legend;
xlabel('X-axis');
ylabel('Y-axis');
title('Ray Tracing with Reflections');
grid on;

% Angles for rays from -45 to +45 degrees
angles = -45:3:45; % from -45 to +45 degrees, every 3 degrees

% Loop through each angle to create rays
for angle = angles
    % Convert angle to radians
    theta = deg2rad(angle);
    
    % Calculate direction based on the angle
    incident_direction = [cos(theta), sin(theta)];
    
    % Create the line from transmitter in the given direction
    ray_end = Tx + incident_direction * 10; % Extend ray length for visibility
    line_mirror_to_rx = createLine(Tx, ray_end);
    
    % Create line for surface segment
    line_surface = createLine(surface1(1,:), surface1(2,:));

    % Calculate intersection
    intersection = intersectLines(line_mirror_to_rx, line_surface);
    
    % Check if intersection is within bounds of the surface segment
    if ~any(isnan(intersection)) && isOnSegment(surface1, intersection)
        % Calculate the normal vector to the surface
        surface_direction = surface1(2,:) - surface1(1,:);
        normal = [-surface_direction(2), surface_direction(1)]; % Perpendicular to the surface
        normal = normal / norm(normal); % Normalize the normal vector

        % Calculate the reflection direction using the reflection formula
        reflection_direction = incident_direction - 2 * dot(incident_direction, normal) * normal;
        reflection_direction = reflection_direction / norm(reflection_direction);  % Normalize the reflected direction
        
        % Extend the reflected ray from the intersection point by 10 units in the reflected direction
        reflected_point = intersection - reflection_direction * 10;  % Adjust this for desired length
        
        % Plot the incident ray (from Tx to intersection on the surface)
        plot([Tx(1), intersection(1)], [Tx(2), intersection(2)], 'r--', 'LineWidth', 1.5, 'DisplayName', 'Incident Ray');
        
        % Plot reflected ray (extend from intersection in the reflected direction)
        plot([intersection(1), reflected_point(1)], [intersection(2), reflected_point(2)], 'b--', 'LineWidth', 1.5, 'DisplayName', 'Reflected Ray');
        
        % Plot intersection point
        plot(intersection(1), intersection(2), 'mx', 'MarkerSize', 10, 'DisplayName', 'Intersection');

    else
        % Skip plotting reflection if intersection is outside of surface bounds
        disp(['No valid reflection path found for angle ', num2str(angle), ': Intersection is outside of the surface segment.']);
    end
end

% Function to create a line representation from two points
function line = createLine(point1, point2)
    % Ensure the inputs are two points with x and y coordinates
    if numel(point1) ~= 2 || numel(point2) ~= 2
        error('Each input should be a 2-element vector representing x and y coordinates.');
    end
    % Create a line struct with a point and a direction vector
    direction = point2 - point1;
    line.point = point1;
    line.direction = direction;
end

% Function to find the intersection of two lines
function intersection = intersectLines(line1, line2)
    % Line 1: point1 + t * direction1
    % Line 2: point2 + s * direction2
    % Solve for t and s where lines intersect

    % Extract components
    x1 = line1.point(1); y1 = line1.point(2);
    dx1 = line1.direction(1); dy1 = line1.direction(2);

    x2 = line2.point(1); y2 = line2.point(2);
    dx2 = line2.direction(1); dy2 = line2.direction(2);

    % Solve linear equations to find intersection parameters
    denominator = dx1 * dy2 - dy1 * dx2;
    if abs(denominator) < 1e-10
        % Lines are parallel or nearly parallel
        intersection = [NaN, NaN];
        return;
    end

    % Calculate intersection
    t = ((x2 - x1) * dy2 - (y2 - y1) * dx2) / denominator;
    intersection = [x1 + t * dx1, y1 + t * dy1];
end

% Function to check if a point is on a line segment
function isOn = isOnSegment(segment, point)
    % Check if point is within bounds of the segment
    x_min = min(segment(1,1), segment(2,1));
    x_max = max(segment(1,1), segment(2,1));
    y_min = min(segment(1,2), segment(2,2));
    y_max = max(segment(1,2), segment(2,2));

    % Check if point is within x and y bounds of the segment
    isOn = point(1) >= x_min && point(1) <= x_max && ...
           point(2) >= y_min && point(2) <= y_max;
end

hold off; % Release the plot hold
