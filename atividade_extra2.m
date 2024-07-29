pkg load communications;

clear all; 
close all;
clc;

% Parâmetros
n_bits = 1000; % Número de bits
R = 0; % Fator de roll-off (especificado, valor de exemplo)
T = 1; % Taxa de símbolo (intervalo de tempo entre símbolos)
Fs = 8; % Taxa de amostragem (amostras por símbolo, ajustado)

% Passo 1: Gerar uma sequência de bits aleatórios
bits = randi([0 1], 1, n_bits);

% Passo 2: Mapear a sequência de bits para símbolos utilizando 4-PAM
amplitudes = [-3 -1 1 3]; % Define os níveis de amplitude
symbols = amplitudes(2*bits(1:end-1) + bits(2:end) + 1); %
% Passo 3: Aplicar o filtro cosseno levantado
span = 6; % Número de períodos de símbolo para o filtro
sps = Fs; % Amostras por símbolo (ajustado)
[h, st] = rcosfir(R, span, sps, T); % Projeto do filtro cosseno levantado
filtered_signal = filter(h, 1, upsample(symbols, sps)); % Aplicação do filtro

% Passo 4: Plotar a forma de onda resultante no domínio do tempo
t = (0:length(filtered_signal)-1)/Fs; % Eixo do tempo
figure(1)
subplot(211)
plot(t, filtered_signal);
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Forma de onda resultante no domínio do tempo');

% Visualização do sinal no domínio da frequência
NFFT = length(filtered_signal); % Número de pontos na FFT
f = Fs/2*linspace(-1,1,NFFT); % Eixo da frequência
S_f = fftshift(fft(filtered_signal, NFFT)); % FFT do sinal
subplot(212)
plot(f, abs(S_f)/NFFT);
xlabel('Frequência (Hz)');
ylabel('Amplitude');
title('Espectro de frequência do sinal filtrado');

% Passo 5: Calcular e plotar a densidade espectral de potência do sinal filtrado
[Pxx, f] = pwelch(filtered_signal, [], [], [], Fs); % Estimativa de densidade espectral de potência
figure(2)
plot(f, 10*log10(Pxx));
xlabel('Frequência (Hz)');
ylabel('Densidade Espectral de Potência (dB/Hz)');
title('Densidade Espectral de Potência do sinal filtrado');

eyediagram(filtered_signal, 2*sps); % Olhograma para visualizar a ISI
