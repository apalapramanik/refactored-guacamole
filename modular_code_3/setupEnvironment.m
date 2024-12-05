


function [surfaces, envWidth, envHeight, envDepth] = setupOfficeEnvironment()
    % Define the environment's dimensions
    envWidth = 60;  % Total width (X-axis)
    envHeight = 20; % Height (Z-axis)
    envDepth = 40;  % Total depth (Y-axis)

    % Initialize figure for 3D plotting
    figure;
    hold on;
    axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    xlim([0 envWidth]); ylim([0 envDepth]); zlim([0 envHeight]);

    % Create outer walls (bounding box)
    surfaces = {};
    surfaces{end+1} = createWall([0 0 0], [envWidth 0 envHeight]); % Back wall
    surfaces{end+1} = createWall([0 envDepth 0], [envWidth envDepth envHeight]); % Front wall
    surfaces{end+1} = createWall([0 0 0], [0 envDepth envHeight]); % Left wall
    % Right wall left open for viewing
    surfaces{end+1} = createWall([0 0 envHeight], [envWidth 0 envHeight]); % Ceiling
    surfaces{end+1} = createFloor([0 0 0], [envWidth envDepth 0]); % Floor

    % Add inner partitions for rooms
    % Room definitions (x_start, y_start, width, depth, height)
    surfaces = addRoom(surfaces, [0, 0, 20, 20, envHeight]); % Office 1
    surfaces = addRoom(surfaces, [20, 0, 10, 10, envHeight]); % Office 2
    surfaces = addRoom(surfaces, [30, 0, 10, 10, envHeight]); % Office 3
    surfaces = addRoom(surfaces, [40, 0, 10, 10, envHeight]); % Office 4
    surfaces = addRoom(surfaces, [50, 0, 10, 10, envHeight]); % Office 5
    surfaces = addRoom(surfaces, [20, 10, 30, 20, envHeight]); % Break Room
    surfaces = addRoom(surfaces, [0, 20, 20, 20, envHeight]); % Kitchen

    % Plot walls and partitions for visualization
    plotSurfaces(surfaces);

    % Set viewing angle and labels
    view(3); % Set 3D view
    title('3D Office Layout', 'FontSize', 18);
    hold off;
end

function surfaces = addRoom(surfaces, roomDims)
    % Add walls for a room
    x_start = roomDims(1);
    y_start = roomDims(2);
    width = roomDims(3);
    depth = roomDims(4);
    height = roomDims(5);

    % Add back wall
    surfaces{end+1} = createWall([x_start, y_start, 0], [x_start + width, y_start, height]);

    % Add front wall
    surfaces{end+1} = createWall([x_start, y_start + depth, 0], [x_start + width, y_start + depth, height]);

    % Add left wall
    surfaces{end+1} = createWall([x_start, y_start, 0], [x_start, y_start + depth, height]);

    % Add right wall
    surfaces{end+1} = createWall([x_start + width, y_start, 0], [x_start + width, y_start + depth, height]);
end

function vertices = createWall(startCorner, endCorner)
    % Create a rectangular wall between two corners
    vertices = [
        startCorner;
        endCorner(1), startCorner(2), startCorner(3);
        endCorner;
        startCorner(1), endCorner(2), endCorner(3)
    ];
end

function vertices = createFloor(startCorner, endCorner)
    % Create a rectangular floor
    vertices = [
        startCorner;
        endCorner(1), startCorner(2), startCorner(3);
        endCorner;
        startCorner(1), endCorner(2), endCorner(3)
    ];
end

function plotSurfaces(surfaces)
    % Plot all surfaces in the environment
    for i = 1:length(surfaces)
        % fill3(surfaces{i}(:, 1), surfaces{i}(:, 2), surfaces{i}(:, 3), [0, 0, 0]); % Light gray walls 0.9,0.9,0.9
        fill3(surfaces{i}(:, 1), surfaces{i}(:, 2), surfaces{i}(:, 3), [0, 0, 0], 'EdgeColor', 'w'); % White edges

    end
    % Add lighting
    % camlight('headlight');
    % lighting phong;
end







