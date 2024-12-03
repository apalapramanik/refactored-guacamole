function ant = create60GHzHPolarizedAntenna()
    % Define the base patch antenna for 60 GHz
    ant = design(patchMicrostrip, 60e9);

    % Dynamically calculate a valid feed offset
    feedOffsetY = min(max(ant.Width / 4, -0.003), 0.003);
    ant.FeedOffset = [0, feedOffsetY]; % Place feed along the y-axis for horizontal polarization
end
