clc; clear all; close all;

pkg load communications;
pkg load signal;

% Definir a string de bits
info = '00011000010111000001100001011100000110000101110000011000010111000001100001011100000110000101110000011000010111000001100001011100';

% Frequência da portadora
Fc = 2000;
Fs = 10000; % Taxa de amostragem
T = 1/Fs;   % Período de amostragem

% Parâmetros para o gráfico
Rb = 1000; % Taxa de bits (exemplo)
M = 16;    % Número de níveis da modulação QAM
T_s = log2(M) / Rb; % Tempo de símbolo calculado

T_amostra = T_s / 1000; % Período de amostragem (exemplo: 100 pontos por período de símbolo)
num_periodos = 4; % Número de períodos para plotar

% Tempo do sinal (para 4 períodos)
t = 0:T_amostra:num_periodos*T_s-T_amostra;

% Número de bits em cada grupo
grupo_bits = 4;

% Calcular o número de grupos
num_grupos = length(info) / grupo_bits;

% Inicializar vetor para armazenar os decimais de 4 em 4 bits
decimais = zeros(1, num_grupos);

% Converter cada grupo de 4 bits para decimal
for i = 1:num_grupos
    % Extrair o grupo de 4 bits
    grupo_binario = info((i-1)*grupo_bits+1 : i*grupo_bits);

    % Converter o grupo de 4 bits para decimal
    decimais(i) = bin2dec(grupo_binario);
end

% Modulação QAM (16-QAM)
info_complexa = qammod(decimais, M);

% Sinal modulado
s_t = info_complexa .* exp(1j*2*pi*Fc*t(1:length(info_complexa)));

% Transmissão - Pegando a parte real para transmitir
s_t_real = real(s_t);

% --- Demodulação ---

% Simular o sinal recebido (neste exemplo, sem ruído)
r_t = s_t_real; % Neste exemplo, o sinal recebido é o sinal transmitido

% Remultiplicar pela portadora complexa conjugada
r_t_complex = r_t .* exp(-1j*2*pi*Fc*t(1:length(r_t)));

% Filtrar componentes de alta frequência com um filtro passa-baixas
filtro_pb = fir1(48, 0.1); % Filtro FIR de ordem 48 com frequência de corte normalizada de 0.1
r_t_filtrado = filter(filtro_pb, 1, r_t_complex);

% Extrair partes real e imaginária
r_real = real(r_t);
r_imag = imag(r_t);

% Combinar partes real e imaginária para formar o sinal demodulado
info_demodulada = r_real + 1j*r_imag;

% Decodificar a informação demodulada
decimais_demodulados = qamdemod(info_demodulada, M);

% Converter decimais de volta para binário
info_reconstituida = '';
for i = 1:length(decimais_demodulados)
    info_reconstituida = [info_reconstituida, dec2bin(decimais_demodulados(i), grupo_bits)];
end

% Exibir a informação original e a reconstituída
disp(['Informação original: ', info]);
disp(['Informação reconstituída: ', info_reconstituida]);


% -------------------------- Plots --------------------------
% Plot do sinal da informação
figure(1)
subplot(1, 2, 1);
plot(1:length(decimais), decimais)
title('Sinal de informação no tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(1, 2, 2);
f = linspace(-Fs/2, Fs/2, length(decimais));
decimais_f = abs(fftshift(fft(decimais)));
plot(f, decimais_f);
title('Espectro do Sinal de informação na freq');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

% Plot do sinal modulado no tempo
figure(2);
subplot(1,2,1);
plot(t(1:length(s_t_real)), s_t_real);
title('Sinal Modulado no Tempo (s\_t\_real)');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Plot do sinal modulado na frequência
subplot(1,2,2);
f = linspace(-Fs/2, Fs/2, length(s_t_real));
S_t_real_f = abs(fftshift(fft(s_t_real)));
plot(f, S_t_real_f);
title('Espectro do Sinal Modulado (s\_t\_real)');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

% Plot do sinal recebido no tempo
figure(3)
subplot(1,2,1);
plot(t(1:length(r_t)), r_t);
title('Sinal Recebido no Tempo (r\_t)');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Plot do sinal recebido na frequência
subplot(1,2,2);
R_t_f = abs(fftshift(fft(r_t)));
plot(f, R_t_f);
title('Espectro do Sinal Recebido (r\_t)');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

% Plot do sinal demodulado no tempo
figure(4)
subplot(1,2,1);
plot(t(1:length(decimais_demodulados)), decimais_demodulados);
title('Sinal recebido');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Plot do sinal demodulado na frequência
subplot(1,2,2);
decimais_demodulados_f = abs(fftshift(fft(decimais_demodulados)));
plot(f, decimais_demodulados);
title('Espectro do Sinal recebido');
xlabel('Frequência (Hz)');
ylabel('Magnitude');
legend('r\_real', 'r\_imag');
