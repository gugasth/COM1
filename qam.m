clc; clear all; close all;

pkg load communications;

% Definir a string de bits
info = '0001100001011100';

% Frequência da portadora
Fp = 1000;

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
w0 = 2 * pi * (Fp);

% Multiplicar sinal modulado pela portadora
parte_real_cos = sinal_modulado_real .* cos(w0 * t);
parte_imaginaria_sen = sinal_modulado_imaginario .* (-sin(w0 * t));
sinal_modulado_cos_sin = parte_real_cos + parte_imaginaria_sen
% Plotar o sinal modulado no tempo
figure(2);
subplot(311)
plot(t, parte_real_cos, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Parte real multiplicada por cos(w0t');
grid on;

subplot(312)
plot(t, parte_imaginaria_sen, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Parte imaginária multiplicada por -sin(w0t)');
grid on;

subplot(313)
plot(t, sinal_modulado_cos_sin, 'b', 'LineWidth', 2);
xlabel('Tempo');
ylabel('Amplitude');
title('Sinal resutante');
grid on;

