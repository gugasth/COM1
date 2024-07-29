clc; clear all; close all;

pkg load communications;

% Definir a string de bits
info = '0001100001011100';

% Frequência da portadora
Fc = 2000;
Fs = 10000; % Taxa de amostragem
T = 1/Fs;   % Período de amostragem

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

% Modulação QAM (16-QAM neste exemplo)
M = 16;
info_complexa = qammod(decimais, M);

% Extrair partes real e imaginária
parte_real = real(info_complexa);
parte_imaginaria = imag(info_complexa);

% Parâmetros para o gráfico
Rb = 1000; % Taxa de bits (exemplo)
T_s = log2(M) / Rb; % Tempo de símbolo calculado

T_amostra = T_s / 1000; % Período de amostragem (exemplo: 100 pontos por período de símbolo)
num_periodos = 4; % Número de períodos para plotar

% Tempo do sinal (para 4 períodos)
t = 0:T_amostra:num_periodos*T_s-T_amostra;

% Inicializar vetores para sinal modulado (parte real e parte imaginária)
sinal_modulado_real = zeros(size(t));
sinal_modulado_imaginario = zeros(size(t));

fator_upsample = 1;

% Upsample
sinal_modulado_real_upsampled = interp(sinal_modulado_real, fator_upsample);
sinal_modulado_imaginario_upsampled = interp(sinal_modulado_imaginario, fator_upsample);


% Mapeamento para sinal modulado (parte real e parte imaginária)
for i = 1:length(parte_real)
    indice_inicio = (i - 1) * round(T_s / T_amostra) + 1;
    indice_fim = i * round(T_s / T_amostra);
    sinal_modulado_real(indice_inicio:indice_fim) = parte_real(i);
    sinal_modulado_imaginario(indice_inicio:indice_fim) = parte_imaginaria(i);
end

% Plotar o sinal modulado (parte real e parte imaginária) no tempo
figure;

% Subplot da parte real
subplot(2, 1, 1);
plot(t, sinal_modulado_real, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Sinal Modulado (Parte Real) 16-QAM');
grid on;

% Subplot da parte imaginária
subplot(2, 1, 2);
plot(t, sinal_modulado_imaginario, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Sinal Modulado (Parte Imaginária) 16-QAM');
grid on;

% Definir frequência angular da portadora
w0 = 2 * pi * (Fc);

% Multiplicar sinal modulado pela portadora
parte_real_cos = sinal_modulado_real .* cos(w0 * t);
parte_imaginaria_sen = sinal_modulado_imaginario .* (-sin(w0 * t));
sinal_modulado_cos_sin = parte_real_cos + parte_imaginaria_sen;

% Plotar o sinal modulado no tempo
figure(2);
subplot(311)
plot(t, parte_real_cos, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Parte real após multiplicar por cos(w0t');
grid on;

subplot(312)
plot(t, parte_imaginaria_sen, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Parte imaginária após multiplicar por -sin(w0t)');
grid on;

subplot(313)
plot(t, sinal_modulado_cos_sin, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Sinal transmitido');
grid on;

% ----------- Demodulação -----------

% Separar em parte real e imaginária
s_I = sinal_modulado_cos_sin .* cos(w0 * t);
s_Q = sinal_modulado_cos_sin .* (-sin(w0 * t));

figure(3);
subplot(311)
plot(t, s_I, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Parte real multiplicada por cos(w0t');
grid on;

subplot(312)
plot(t, s_Q, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Parte imaginária multiplicada por -sin(w0t)');
grid on;


% Filtros passa-baixa
order = 6;
cutoff = 0.1 * (Fs / 2);
[b, a] = butter(order, cutoff / (Fs / 2), 'low');
r_I = filter(b, a, s_I);
r_Q = filter(b, a, s_Q);

figure(4);
subplot(311)
plot(t, r_I, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Parte real multiplicada por cos(w0t');
grid on;

subplot(312)
plot(t, r_Q, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Parte imaginária multiplicada por -sin(w0t)');
grid on;

y_t = r_I + r_Q;
subplot(313)
plot(t, y_t, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
ylim([-6 6])
title('Sinal recebido');
grid on;

% Downsampling
downsample_factor = round(T_s / T_amostra);
I_downsampled = downsample(r_I, downsample_factor);
Q_downsampled = downsample(r_Q, downsample_factor);

% Decodificação dos dados
% Combine I e Q para formar os símbolos complexos
info_complexa_demod = I_downsampled + 1i * Q_downsampled;

% Demodulação QAM
decimais_demodulados = qamdemod(info_complexa_demod, M);

% Converter de volta para bits
info_demodulado = dec2bin(decimais_demodulados, grupo_bits);

% Concatenar os bits
info_recuperado = reshape(info_demodulado', 1, []);
info_recuperado = info_recuperado(1:length(info));  % Ajustar o comprimento para o original

% Exibir resultados
disp(['Informações originais: ', info]);
disp(['Informações recebidas: ', info_recuperado]);
