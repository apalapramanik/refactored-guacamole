% Define Transmitter, Receiver, and Surfaces
Tx = [6, 0];               % Transmitter position
Rx = [7, 1];               % Receiver position

surface1 = [4, -35; 4, 35];  % Surface 1 defined by two points (x1, y1) and (x2, y2)
surface2 = [8, -35; 8, 35];   % Surface 2 defined by two points (x1, y1) and (x2, y2)

% Create a figure for plotting
figure;
hold on;
plot(Tx(1), Tx(2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Transmitter');
%plot(Rx(1), Rx(2), 'bo', 'MarkerSize', 8, 'DisplayName', 'Receiver');
plot(surface1(:,1), surface1(:,2), 'k-', 'LineWidth', 2, 'DisplayName', 'Surface 1');
plot(surface2(:,1), surface2(:,2), 'k-', 'LineWidth', 2, 'DisplayName', 'Surface 2');
legend;
xlabel('X-axis');
ylabel('Y-axis');
title('Ray Tracing with Double Reflections');
grid on;

% Angles for rays from -45 to +45 degrees
angles = -90:15:90; % from -45 to +45 degrees, every 15 degrees

% Loop through each angle to create rays
for angle = angles
    % Convert angle to radians
    theta = deg2rad(angle);
    
    % Calculate direction based on the angle
    incident_direction = [cos(theta), sin(theta)];
    
    % Create the line from transmitter in the given direction
    ray_end = Tx + incident_direction * 10; % Extend ray length for visibility
    line_mirror_to_rx = createLine(Tx, ray_end);
    
    % Create line for surface segments
    line_surface1 = createLine(surface1(1,:), surface1(2,:));
    line_surface2 = createLine(surface2(1,:), surface2(2,:));

    % Calculate intersection with Surface 1
    intersection1 = intersectLines(line_mirror_to_rx, line_surface1);
    
    % Check if intersection is within bounds of Surface 1
    if ~any(isnan(intersection1)) && isOnSegment(surface1, intersection1)
        % Plot the incident ray (from Tx to intersection on Surface 1)
        plot([Tx(1), intersection1(1)], [Tx(2), intersection1(2)], 'r--', 'LineWidth', 1.5, 'DisplayName', 'Incident Ray');
        
        % Calculate the normal vector to Surface 1
        surface1_direction = surface1(2,:) - surface1(1,:);
        normal1 = [-surface1_direction(2), surface1_direction(1)]; % Perpendicular to the surface
        normal1 = normal1 / norm(normal1); % Normalize the normal vector

        % Calculate the reflection direction using the reflection formula for Surface 1
        reflection_direction1 = incident_direction - 2 * dot(incident_direction, normal1) * normal1;
        reflection_direction1 = reflection_direction1 / norm(reflection_direction1);  % Normalize the reflected direction
        
        % Calculate the intersection of the reflected ray with Surface 2
        reflected_ray_end = intersection1 + reflection_direction1 * 10;  % Extend ray length for visibility
        line_reflected_to_surface2 = createLine(intersection1, reflected_ray_end);
        
        % Calculate intersection with Surface 2
        intersection2 = intersectLines(line_reflected_to_surface2, line_surface2);
        
        % Check if intersection is within bounds of Surface 2
        if ~any(isnan(intersection2)) && isOnSegment(surface2, intersection2)
            % Plot reflected ray from Surface 1 to Surface 2
            plot([intersection1(1), intersection2(1)], [intersection1(2), intersection2(2)], 'b--', 'LineWidth', 1.5, 'DisplayName', 'Reflected Ray 1');
            
            % Calculate the normal vector to Surface 2
            surface2_direction = surface2(2,:) - surface2(1,:);
            normal2 = [-surface2_direction(2), surface2_direction(1)]; % Perpendicular to the surface
            normal2 = normal2 / norm(normal2); % Normalize the normal vector

            % Calculate the reflection direction using the reflection formula for Surface 2
            reflection_direction2 = reflection_direction1 - 2 * dot(reflection_direction1, normal2) * normal2;
            reflection_direction2 = reflection_direction2 / norm(reflection_direction2);  % Normalize the reflected direction

            % Plot second reflection
            second_reflection_end = intersection2 - reflection_direction2 * 10;  % Extend ray length for visibility
            plot([intersection2(1), second_reflection_end(1)], [intersection2(2), second_reflection_end(2)], 'g--', 'LineWidth', 1.5, 'DisplayName', 'Reflected Ray 2');
        end
    else
        % Skip plotting reflection if intersection with Surface 1 is outside the surface bounds
        disp(['No valid reflection path found for angle ', num2str(angle), ': Intersection 1 is outside of Surface 1 segment.']);
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
