function p_received = PathLoss_LOS(tx_pos, rx_pos, p_t, g_t, g_r, lambda)

xdiff = abs(tx_pos(1) - rx_pos(1));
ydiff = abs(tx_pos(2) - rx_pos(2));
zdiff = abs(tx_pos(3) - rx_pos(3));

d = sqrt(xdiff ^ 2 + ydiff ^ 2 + zdiff ^ 2);

p_received = p_t * g_t * g_r * (lambda / (4 * pi * d)) ^ 2;

end