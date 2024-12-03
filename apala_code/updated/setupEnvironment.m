% EnvironmentSetup.m
% function [surfaces, envWidth, envHeight, envDepth] = setupEnvironment()
%     % Define the environment's dimensions
%     envWidth = 50;
%     envHeight = 50;
%     envDepth = 50;
% 
%     % Initialize figure for 3D plotting
%     figure;
%     hold on;
%     axis equal;
%     xlabel('X'); ylabel('Y'); zlabel('Z');
%     xlim([0 envWidth]); ylim([0 envDepth]); zlim([0 envHeight]);
% 
%     % Create walls and store them as reflective surfaces
%     surfaces = {};
%     surfaces{end+1} = createWall([0 0 0], [envWidth 0 envHeight], true); % Back wall
%     surfaces{end+1} = createWall([0 envDepth 0], [envWidth envDepth envHeight], true); % Front wall
%     surfaces{end+1} = createWall([0 0 0], [0 envDepth envHeight], true); % Left wall
%     surfaces{end+1} = createWall([envWidth 0 0], [envWidth envDepth envHeight], true); % Right wall
%     surfaces{end+1} = createWall([0 0 envHeight], [envWidth 0 envHeight], true); % Top wall
%     surfaces{end+1} = createWall([0 envDepth envHeight], [envWidth envDepth envHeight], true); % Top front wall
%     surfaces{end+1} = createFloor([0 0 0], [envWidth envDepth 0], true); % Floor
% 
%     % Create obstacles
%     obstacleSurfaces1 = createObstacle([10 10 0], [5 5 3], true);
%     obstacleSurfaces2 = createObstacle([20 20 0], [4 4 4], true);
%     surfaces = [surfaces, obstacleSurfaces1{:}, obstacleSurfaces2{:}];
% end

function createEnvironmentWithReflections()
    % Define the environment's dimensions
    envWidth = 40; % Width of the environment
    envHeight = 20; % Height of the environment
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

    % Generate and reflect rays using all surfaces
    plotRaysWithReflections(Tx, surfaces);

    % Plot the transmitter (ensure it's plotted last to appear on top)
    plot3(Tx(1), Tx(2), Tx(3), 'ro', 'MarkerSize', 20, 'LineWidth', 3);

    % Create dummy lines for the legend (no actual data points)
    h1 = plot3(nan, nan, nan, 'g-', 'LineWidth', 2); % Incident Ray
    h2 = plot3(nan, nan, nan, 'r-', 'LineWidth', 2); % 1st Reflection
    h3 = plot3(nan, nan, nan, 'b-', 'LineWidth', 2); % 2nd Reflection
    h4 = plot3(nan, nan, nan, 'k--', 'LineWidth', 1.5); % Dotted Line

    % Add a single legend for the four lines
     legend([h1, h2, h3, h4], {'Incident Ray', '1st Reflection', '2nd Reflection', 'No Reflection'}, ...
        'Location', 'bestoutside', 'FontSize', 14, 'LineWidth', 1.5);

    hold off;
    view(3); % Set 3D view
    title('3D Environment with Ray Tracing and Up to Two Reflections', 'FontSize', 28);
end

% Function to create a wall between two corners in 3D space and return its vertices
function vertices = createWall(startCorner, endCorner, show)
    vertices = [
        startCorner;
        endCorner(1), startCorner(2), startCorner(3);
        endCorner;
        startCorner(1), endCorner(2), endCorner(3)
    ];
    if show
        fill3(vertices(:, 1), vertices(:, 2), vertices(:, 3), [0.9, 0.9, 0.9]); % Light gray color for floor
    end
end



% Function to create a floor between two corners and return its vertices
function vertices = createFloor(startCorner, endCorner, show)
    vertices = [
        startCorner;
        endCorner(1), startCorner(2), startCorner(3);
        endCorner;
        startCorner(1), endCorner(2), endCorner(3)
    ];
    if show
        fill3(vertices(:, 1), vertices(:, 2), vertices(:, 3), [0.9, 0.9, 0.9]); % Light gray color for floor
    end
    
end

% Function to create a rectangular obstacle and return its surfaces as a cell array of vertices
function surfaces = createObstacle(position, size, show)
    x = [0 1 1 0 0 1 1 0] * size(1) + position(1);
    y = [0 0 1 1 0 0 1 1] * size(2) + position(2);
    z = [0 0 0 0 1 1 1 1] * size(3) + position(3);

    vertices = [x', y', z'];
    faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8];
    surfaces = cell(6, 1);
    for i = 1:6
        surfaces{i} = vertices(faces(i, :), :);
        if show
            patch('Vertices', vertices, 'Faces', faces(i, :), 'FaceColor', [0.5, 0.5, 0.5]);
        end
    end
end
