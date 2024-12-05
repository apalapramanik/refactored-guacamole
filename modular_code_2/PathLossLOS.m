% PathLoss.m
function [pr, color] = PathLossLOS(d, Tx_power, freq)
    g_t = 1;
    g_r = 1;
    c = 3e8; % Speed of light in m/s
    lambda = c / freq; % Wavelength calculation
    Tx_power = 10 ^ (Tx_power / 10);
    pr = Tx_power * g_t * g_r * (lambda / (4 * pi * d))^2;
    pr = 10 * log10(pr);
    startValue = -10;
    stepSize = 10;
    val = startValue;
    colors = ["m", "r", "y", "g", "c", "b", "k"];
    i = 1;
    while i < numel(colors) & val > pr
         val = val - stepSize;
         i = i + 1;
    end
    color = colors(i);
end

% function [pr, color] = PathLossLOS(d, Tx_power)
%     % Constants
%     g_t = 1; % Transmitter gain
%     g_r = 1; % Receiver gain
%     c = 3e8; % Speed of light in m/s
%     freq = 60e9; % Frequency in Hz (60 GHz)
%     lambda = c / freq; % Wavelength calculation
% 
%     % Calculate received power
%     Tx_power = 10 ^ (Tx_power / 10);
%     pr = Tx_power * g_t * g_r * (lambda / (4 * pi * d))^2;
%     pr = 10 * log10(pr); % Convert to dBm
% 
%     % Assign color based on finer thresholds
%     if pr > 0
%         color = "m"; % Magenta
%     elseif pr > -10
%         color = "c"; % Cyan
%     elseif pr > -20
%         color = [0.5, 1, 0.5]; % Light green
%     elseif pr > -30
%         color = "g"; % Green
%     elseif pr > -40
%         color = "y"; % Yellow
%     elseif pr > -50
%         color = [1, 0.5, 0.5]; % Light red
%     elseif pr > -60
%         color = "r"; % Red
%     elseif pr > -70
%         color = [0.5, 0.5, 1]; % Light blue
%     else
%         color = "b"; % Blue
%     end
% end
