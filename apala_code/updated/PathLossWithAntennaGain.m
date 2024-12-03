% PathLossWithAntennaGain.m
% function [pr, color] = PathLossWithAntennaGain(d, Tx_power, ant, theta, phi)
%     g_t = pattern(ant, 60e9, theta * (180/pi), phi * (180/pi)); % Gain in dB
%     g_r = 1; % Assume isotropic receiver for simplicity
%     lambda = 3e8 / 60e9; % Wavelength for 60 GHz
%     color = "k";
%     Tx_power = 10 ^ (Tx_power / 10);
%     pr = Tx_power * g_t * g_r * (lambda / (4 * pi * d))^2;
%     pr = 10 * log10(pr);
%     if pr > 0
%         color = "m";
%     elseif pr > -10
%         color = "c";
%     elseif pr > -20
%         color = "g";
%     elseif pr > -30
%         color = "y";
%     elseif pr > -40
%         color = "r";
%     elseif pr > -50
%         color = "b";
%     end
% end


function [pr, color] = PathLossWithAntennaGain(d, txPower, ant, theta, phi)
    % Parameters
    g_t = 1; % Default transmitter gain (updated later)
    g_r = 1; % Receiver gain (can be customized)
    lambda = 3e8 / 60e9; % Wavelength for 60 GHz
    txPowerLinear = 10^(txPower / 10); % Convert Tx power to linear scale

    % Compute antenna gain using the radiation pattern
    patternData = pattern(ant, 60e9, theta * (180 / pi), phi * (180 / pi));
    g_t = 10^(patternData / 10); % Convert gain from dB to linear scale

    % Calculate path loss using the Friis free-space equation
    pr = txPowerLinear * g_t * g_r * (lambda / (4 * pi * d))^2;
    pr = 10 * log10(pr); % Convert back to dB

    % Assign color based on received power level
    if pr > 0
        color = 'm'; % Magenta for strong signal
    elseif pr > -10
        color = 'c'; % Cyan for moderate signal
    elseif pr > -20
        color = 'g'; % Green for weak signal
    elseif pr > -30
        color = 'y'; % Yellow for very weak signal
    else
        color = 'r'; % Red for no signal
    end
end
