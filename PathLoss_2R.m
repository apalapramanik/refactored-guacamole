function p_received = PathLoss_2R(tx_pos, rx_pos, p_t, g_t, g_r, lambda)

xdiff = abs(tx_pos(1) - rx_pos(1));
ydiff = abs(tx_pos(2) - rx_pos(2));
ht = tx_pos(3);
hr = rx_pos(3);

d = sqrt(xdiff ^ 2 + ydiff ^ 2);

p_received = p_t * g_t * g_r * ht ^ 2 * hr ^ 2 / (d ^ 4);

end