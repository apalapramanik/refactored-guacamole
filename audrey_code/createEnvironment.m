% Main function to set up the environment
function createEnvironment()
    % Define the environment's dimensions
    envWidth = 10; % Width of the environment
    envHeight = 10; % Height of the environment
    envDepth = 10; % Depth of the environment

    % Initialize figure for 3D plotting
    figure;
    hold on;
    axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    xlim([0 envWidth]); ylim([0 envDepth]); zlim([0 envHeight]);

    % Create walls
    createWall([0 0 0], [envWidth 0 envHeight]); % Back wall
    createWall([0 envDepth 0], [envWidth envDepth envHeight]); % Front wall
    createWall([0 0 0], [0 envDepth envHeight]); % Left wall
    createWall([envWidth 0 0], [envWidth envDepth envHeight]); % Right wall

    % Create floor and ceiling
    createFloor([0 0 0], [envWidth envDepth 0]); % Floor
    createFloor([0 0 envHeight], [envWidth envDepth envHeight]); % Ceiling

    % Create obstacles
    createObstacle([3 3 0], [1 1 2]); % Obstacle 1
    createObstacle([7 7 0], [1.5 1 3]); % Obstacle 2

    % Plot rays originating from a sample transmitter position
    transceiverPosition = [5 5 1]; % Example transmitter position
    plotRays(transceiverPosition, 5); % Generate and plot 5 rays

    hold off;
    view(3); % Set 3D view
    title('3D Environment with Walls, Floor, Ceiling, and Obstacles');
end

% Function to create a wall between two corners in 3D space
function createWall(startCorner, endCorner)
    % Draw a plane representing a wall
    fill3([startCorner(1), endCorner(1), endCorner(1), startCorner(1)], ...
          [startCorner(2), startCorner(2), endCorner(2), endCorner(2)], ...
          [startCorner(3), endCorner(3), endCorner(3), startCorner(3)], ...
          [0.8, 0.8, 0.8]); % Gray color for walls
end

% Function to create a floor or ceiling between two corners
function createFloor(startCorner, endCorner)
    % Draw a plane representing a floor or ceiling
    fill3([startCorner(1), endCorner(1), endCorner(1), startCorner(1)], ...
          [startCorner(2), startCorner(2), endCorner(2), endCorner(2)], ...
          [startCorner(3), startCorner(3), endCorner(3), endCorner(3)], ...
          [0.9, 0.9, 0.9]); % Light gray color for floor/ceiling
end

% Function to create a rectangular obstacle
function createObstacle(position, size)
    % Define the 8 corners of the cuboid
    x = [0 1 1 0 0 1 1 0] * size(1) + position(1);
    y = [0 0 1 1 0 0 1 1] * size(2) + position(2);
    z = [0 0 0 0 1 1 1 1] * size(3) + position(3);

    % Define faces of the cuboid
    faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8];

    % Draw the cuboid as a set of faces
    patch('Vertices', [x', y', z'], 'Faces', faces, 'FaceColor', [0.5, 0.5, 0.5]);
end

% Function to plot rays originating from a transmitter in random directions
function plotRays(position, numRays)
    for i = 1:numRays
        % Generate a random direction for the ray
        direction = rand(1, 3) - 0.5;
        direction = direction / norm(direction); % Normalize direction

        % Define the ray end point for visualization
        endPoint = position + direction * 5; % Scale to adjust ray length

        % Plot the ray
        plot3([position(1) endPoint(1)], [position(2) endPoint(2)], [position(3) endPoint(3)], 'r-');
    end
end