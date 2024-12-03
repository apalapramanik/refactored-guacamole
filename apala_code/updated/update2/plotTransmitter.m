function plotTransmitter(Tx)
    % Plot the transmitter position with marker and label
    plot3(Tx(1), Tx(2), Tx(3), 'ro', 'MarkerSize', 10, 'DisplayName', 'Transmitter');
    text(Tx(1), Tx(2), Tx(3), 'Tx', 'HorizontalAlignment', 'right');
end
