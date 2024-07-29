clc; clear all; close all;

pkg load communications;
pkg load signal;

k = log2(16);
num_bits = k * 100000;

% Frequência da portadora
Fc = 2000;
Fs = 10000; % Taxa de amostragem

% fator upsample
N = 100;

% Parâmetros para o gráfico
Rb = 1000; % Taxa de bits
M = 16;    % Número de níveis da modulação QAM
T_s = log2(M) / Rb; % Tempo de símbolo calculado

T_amostra = num_bits / Fs;
num_periodos = 4; % Número de períodos para plotar

% Tempo do sinal (para 4 períodos)
Fa = N * Rb/log2(M);
Ta = 1/Fa;
tempo = num_bits / Rb;
t = [0:Ta:tempo-Ta];


info = randint(1, num_bits, 2);
info = reshape(info, length(info)/k, k);
info = transpose(bi2de(info));

% Modulação QAM (16-QAM)
info_complexa = qammod(info, M);
f1 = scatterplot (info_complexa(1:length(info_complexa)));
title ('Constelação 16−QAM sem ruído')
axis([-5 5 -5 5]); % Ajuste o eixo para melhor visualização

info_I = real (info_complexa);
info_Q = imag(info_complexa);

% Upsample
info_I_up = upsample(info_I,N);
info_Q_up = upsample(info_Q,N);

filtro_tx = ones(1,N);
sinal_I = filter (filtro_tx, 1, info_I_up) ;
sinal_Q = filter (filtro_tx, 1, info_Q_up);

Portadora_I = (cos(2*pi*Fc.* t (1:length( sinal_I ) ) ) ) ;
Portadora_Q = (cos(2*pi*Fc.*t(1:length(sinal_Q)) + pi /2) ) ;

sinal_I = sinal_I' .* Portadora_I;
sinal_Q = sinal_Q' .* Portadora_Q;

sinal_TX = sinal_I - sinal_Q;

% --- Demodulação ---

%% Recepção do sinal
filtro_rx = fliplr(filtro_tx);
SNR = 10;

sinal_RX = awgn(sinal_TX,SNR,'measured');

sinal_RX_I = sinal_RX.*Portadora_I;
sinal_RX_Q = sinal_RX.*-Portadora_Q;

sinal_Rx_filtrado_I = filter ( filtro_rx ,1, sinal_RX_I)/N;
sinal_Rx_filtrado_Q = filter ( filtro_rx ,1, sinal_RX_Q)/N;

f5 = scatterplot ( sinal_Rx_filtrado_I (N:N:end).*2);
title ('Sinal PAM filtrado (fase)')

f6 = scatterplot (sinal_Rx_filtrado_Q(N:N:end).*2);
title ('Sinal PAM filtrado (quadratura)')

sinal_16Qam_PLOT = sinal_Rx_filtrado_I(N:N:end).*2 + j*(sinal_Rx_filtrado_Q(N:N:end).*2);
f7 = scatterplot (sinal_16Qam_PLOT);
title ('Sinal 16−QAM filtrado')

info_Rx_I = sinal_Rx_filtrado_I (N:N:end).*2;
info_Rx_Q = sinal_Rx_filtrado_Q(N:N:end).*2;
info_Rx_Q = info_Rx_Q.*j;

info_Rx = info_Rx_I + info_Rx_Q;

info_Rx = qamdemod(info_Rx, 16);

bits_Rx = reshape(de2bi(info_Rx),[num_bits/k,k]);

decimais_recebidos = bi2de(bits_Rx);

