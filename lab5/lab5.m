pkg load signal
pkg load communications

clc;
clear all;
close all;

var_ruido = 0.1;
limiar  = 0;
N = 50;
info = randint(1, 2000, 2); % sinal de informação gerado
info_up = upsample(info, N); % sinal de informação com upsample realizado
filtro_tx = ones(1, N);      % filtro de 1's
info_tx = filter(filtro_tx, 1, info_up)*(2*5)-5; % info filtrada
ruido = sqrt(var_ruido)*randn(1, length(info_tx)); % ruído gerado pela variancia
info_rx = info_tx + ruido; % rx é tx com ruido
info_rx_amostrada = info_rx(N/2:N:end); % rx amostrado
info_hat = info_rx_amostrada > limiar; % pega o que estiver acima do limiar
num_erro = sum(xor(info, info_hat))
taxa_erro = num_erro/length(info)
