% Define Transmitter, Receiver, and Surface(s)
Tx = [2, 8];               % Transmitter position
Rx = [3,2];               % Receiver position
surface1 = [1, 0; 1, 12];   % Surface defined by two points (x1, y1) and (x2, y2)

% Plot Transmitter, Receiver, and Surface
figure;
hold on;
plot(Tx(1), Tx(2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Transmitter');
plot(Rx(1), Rx(2), 'bo', 'MarkerSize', 8, 'DisplayName', 'Receiver');
plot(surface1(:,1), surface1(:,2), 'k-', 'LineWidth', 2, 'DisplayName', 'Surface 1');
legend;
xlabel('X-axis');
ylabel('Y-axis');
title('Ray Tracing Setup');
grid on;

% Mirror Transmitter across the surface and plot it
mirror_Tx = Tx;
mirror_Tx(1) = 2 * surface1(1,1) - Tx(1);  % Reflect across x = 5
plot(mirror_Tx(1), mirror_Tx(2), 'go', 'MarkerSize', 8, 'DisplayName', 'Mirrored Transmitter');

% Display mirrored transmitter position
disp(['Mirrored Transmitter Position: (', num2str(mirror_Tx(1)), ', ', num2str(mirror_Tx(2)), ')']);

% Create the line from mirrored transmitter to receiver
line_mirror_to_rx = createLine(mirror_Tx, Rx);
disp(['Line from Mirrored Tx to Rx: Point (', num2str(line_mirror_to_rx.point(1)), ', ', num2str(line_mirror_to_rx.point(2)), ...
      ') Direction (', num2str(line_mirror_to_rx.direction(1)), ', ', num2str(line_mirror_to_rx.direction(2)), ')']);

% Create line for surface segment
line_surface = createLine(surface1(1,:), surface1(2,:));
disp(['Surface Line: Point (', num2str(line_surface.point(1)), ', ', num2str(line_surface.point(2)), ...
      ') Direction (', num2str(line_surface.direction(1)), ', ', num2str(line_surface.direction(2)), ')']);

% Calculate intersection
intersection = intersectLines(line_mirror_to_rx, line_surface);

% Display intersection debug information
disp(['Calculated Intersection: (', num2str(intersection(1)), ', ', num2str(intersection(2)), ')']);

% Check if intersection is within bounds of the surface segment
if ~any(isnan(intersection)) && isOnSegment(surface1, intersection)
    disp(['Intersection point: (', num2str(intersection(1)), ', ', num2str(intersection(2)), ')']);
    
    % Calculate the reflection vector
    normal = [line_surface.direction(2), -line_surface.direction(1)]; % Normal to surface
    normal = normal / norm(normal); % Normalize normal
    
    incident = line_mirror_to_rx.direction;
    
    % Reflection formula: R = I - 2 * (I . N) * N
    reflection_direction = incident - 2 * dot(incident, normal) * normal;
    reflection_direction = reflection_direction / norm(reflection_direction);  % Normalize the reflected direction
    
    % Calculate new reflected point
    reflected_point = intersection + reflection_direction;  % Move the intersection point in the reflected direction

    % Plot direct and reflected rays
    plot([Tx(1), intersection(1)], [Tx(2), intersection(2)], 'r--', 'LineWidth', 1.5, 'DisplayName', 'Direct Ray');
    plot([intersection(1), Rx(1)], [intersection(2), Rx(2)], 'b--', 'LineWidth', 1.5, 'DisplayName', 'Reflected Ray');
    
    %plot([intersection(1), reflected_point(1)], [intersection(2), reflected_point(2)], 'g--', 'LineWidth', 1.5, 'DisplayName', 'Reflected Ray');
else
    disp('No valid reflection path found: Intersection is outside of the surface segment.');
end

% Plot intersection if valid
if ~any(isnan(intersection))
    plot(intersection(1), intersection(2), 'mx', 'MarkerSize', 10, 'DisplayName', 'Intersection');
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
