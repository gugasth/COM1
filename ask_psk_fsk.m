pkg load communications   % Carrega o pacote de comunicações para usar funções adicionais

clc; close all; clear all;   

A_nrz = 1;  % Amplitude do sinal NRZ (Non Return to Zero)
A_c = 1;    % Amplitude da portadora
N = 100;    % Número de amostras por bit
M = 4;      % Número de símbolos (para geração de informação randômica)
Rb = 1e3;   % Taxa de bits, ex 1000 bits por segundo
Tb = 1/Rb;  % Duração de cada bit em segundos
Fs = Rb*N;  % Frequência de amostragem
fc = Fs/50; % Frequência da portadora
N_periodo_c = N/(Fs/fc); % Número de amostras por período da portadora

Ts = 1/Fs;  % Período de amostragem
t = [0:Ts:1-Ts]; % Vetor de tempo para um segundo de duração

filtro_NRZ = ones(1,N); % Filtro NRZ (Non Return to Zero)

info = randi([0 M-1],1,Rb); % Gera informações aleatórias (símbolos)
info_up = upsample(info, N); % Sobreamostra as informações para ajustar ao número de amostras por bit
sinal_tx = filter(filtro_NRZ, 1, info_up)*A_nrz; % Sinal transmitido modulado em amplitude

% Modulação PSK (Phase Shift Keying)
x_psk = A_c*sin(2*pi*fc*t + (2*pi*sinal_tx/M));

% Modulação ASK (Amplitude Shift Keying)
x_ask = A_c*sinal_tx.*sin(2*pi*fc*t);

% Modulação FSK (Frequency Shift Keying)
x_fsk = A_c*sin(2*pi*fc*((sinal_tx+1)).*t);

% Plotagem dos sinais modulados
figure;
subplot(411)
plot(t, sinal_tx)
title('Sinal NRZ')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 10*Tb])

subplot(412)
plot(t, x_psk)
title('PSK')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 10*Tb])

subplot(413)
plot(t, x_ask)
title('ASK')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 10*Tb])

subplot(414)
plot(t, x_fsk)
title('FSK')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 10*Tb])
