pkg load signal
pkg load communications

clc;
clear all;
close all;

var_ruido = 0.1;
limiar  = 0;
N = 50;
info = randint(1, 20000, 2);
info_up = upsample(info, N);
filtro_tx = ones(1, N);
info_tx = filter(filtro_tx, 1, info_up)*(2*5)-5;
ruido = sqrt(var_ruido)*randn(1, length(info_tx));
info_rx = info_tx + ruido;
info_rx_amostrada = info_rx(N/2:N:end);
info_hat = info_rx_amostrada > limiar;
num_erro = sum(xor(info, info_hat))
taxa_erro = num_erro/length(info)
