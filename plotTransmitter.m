% TransmitterSetup.m
function plotTransmitter(Tx)
    hold on;
    plot3(Tx(1), Tx(2), Tx(3), 'ro', 'MarkerSize', 10, 'DisplayName', 'Transmitter');
end