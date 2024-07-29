close all; clear all; clc;
pkg load signal;
pkg load communications;

% Carregar o arquivo de áudio
[audio_signal, sample_rate] = audioread('../lab3/music.wav');

% Normalizar o sinal de áudio entre -1 e 1
audio_signal = audio_signal / max(abs(audio_signal));

% Definir a frequência de amostragem
fs = sample_rate;

% Definir o período de amostragem
Ts = 1/fs;

% Definir o tempo de duração do sinal
t_inicial = 0;
t_final = length(audio_signal)/fs;

% Vetor de tempo com o mesmo tamanho do sinal de áudio
t = linspace(t_inicial, t_final, length(audio_signal));
tsine = t;

% Sinal a ser transmitido
signal = audio_signal';

signalsine = signal;

% Criando um trem de impulsos com período de 2T
impulse_train = zeros(size(t));
impulse_train(mod(t, 1/fs) == 0) = 1;

signal_sampled = signal .* impulse_train;

% Quantidade de níveis desejada (tirando o 0)
n=2;
num_levels = 2^n;

% Gerando os níveis de quantização automaticamente
levels = linspace(-1, 1, num_levels);

% Verifica se o vetor possui algum elemento com "0"
for i = 1:length(levels)
    if levels(i) == 0
        levels(i) = [];
        break;
    end
end

% Quantização
quantized_signal = zeros(size(signal_sampled));
for i = 1:length(signal_sampled)
    for j = 1:length(levels)
        if signal_sampled(i) <= levels(j)
            quantized_signal(i) = levels(j);
            break;
        end
    end
end

% Restante do código permanece o mesmo


% Restante do código permanece o mesmo


  figure(1)
  subplot(411)
  plot(t,signal)
  grid on;
  title('Sinal Senoidal (Dominio do tempo)')

  subplot(412)
  stem(t,impulse_train, 'MarkerFaceColor', 'b')
  grid on;
  title('Trem de impulsos (Dominio do tempo)')

  subplot(413)
  stem(t,signal_sampled, 'LineStyle','none', 'MarkerFaceColor', 'b')
  grid on;
  title('Sinal Senoidal Amostrado (Dominio do tempo)')

  subplot(414)
  stem(t,quantized_signal, 'LineStyle','none', 'MarkerFaceColor', 'b')
  hold on;
  plot(t,signal, 'r')
  xlim([0 3*T])
  grid on;
  title('Sinal Senoidal Amostrado e Quantizado (Dominio do tempo)')

  % Desloca o vetor quantizado para 0 ou mais
  min_value = min(quantized_signal);
  quantized_signal = quantized_signal - min_value;

  % Multiplica os valores quantizados para que sejam números inteiros
  num_intervals = num_levels - 1; % Número de intervalos entre os níveis
  quantized_signal_int = quantized_signal * num_intervals;

  % Convertendo valores quantizados inteiros para binário
  binary_signal = de2bi(quantized_signal_int, n);

  % Concatenando os valores binários em um único vetor
  binary_signal_concatenated = reshape(binary_signal.', 1, []);

  % Vetor de tempo
  t = linspace(0, 1, length(binary_signal_concatenated) * 2);

  % Repetindo cada valor do sinal
  repeated_signal = reshape(repmat(binary_signal_concatenated, 2, 1), 1, []);

  % realizando a superamostragem do sinal com a função upper

  % Superamostragem
  n = 10;
  amplitude =5;
  repeated_signal_up = upsample(repeated_signal, n);

  filtr_tx = ones(1, n);
  filtered_signal = filter(filtr_tx, 1, repeated_signal_up)*2*amplitude-amplitude;

  % criando um novo vetor de t para o sinal filtrado
  t_super = linspace(0, 1, length(filtered_signal));

  var_noise = 0.1;
  transmission_noise = sqrt(var_noise)*randn(1,length(filtered_signal));

  transmitted_signal = filtered_signal + transmission_noise;

  % Plotando o sinal
  figure(2)
  subplot(211)
  plot(t,repeated_signal, 'LineWidth', 2);
  ylim([-0.2, 1.2]);
  xlim([0, 50*T]);
  xlabel('Tempo');
  ylabel('Amplitude');
  title('Sinal Binário como Onda Quadrada');
  grid on;

  subplot(212)
  plot(t_super,filtered_signal, 'LineWidth', 2);
  xlim([0, 50*T]);
  ylim([-amplitude*1.2 , amplitude*1.2]);
  xlabel('Tempo');
  ylabel('Amplitude');
  title('Sinal Binário como Onda Quadrada - Superamostrado');
  grid on;

  figure(5)
  subplot(311)
  plot(t_super,transmission_noise, 'LineWidth', 2);
  xlim([0, 50*T]);
  ylim([-amplitude*1.2 , amplitude*1.2]);
  xlabel('Tempo');
  ylabel('Amplitude');
  title('Sinal Ruidoso - AWGN');
  grid on;

  subplot(312)
  plot(t_super,filtered_signal, 'LineWidth', 2);
  xlim([0, 50*T]);
  ylim([-amplitude*1.2 , amplitude*1.2]);
  xlabel('Tempo');
  ylabel('Amplitude');
  title('Sinal Binário como Onda Quadrada');
  grid on;

  subplot(313)
  plot(t_super,transmitted_signal, 'LineWidth', 2);
  xlim([0, 50*T]);
  ylim([-amplitude*1.2 , amplitude*1.2]);
  xlabel('Tempo');
  ylabel('Amplitude');
  title('Sinal Transmitido no Meio de Transmissão');
  grid on;

  % Recepção:

  % definindo o limiar (valor que vai decidir se o sinal é 0 ou 1)
  limiar = 0;

  % amostrando o sinal recebido
  received_signal = transmitted_signal(n/2:n:end);
  received_binary = received_signal > limiar;

  t_received = linspace(0, 1, length(t_super)/n);

  % Plotando o sinal
  % Plotting the signal
  figure(3)

  subplot(411)
  plot(t_received, received_signal,  'LineWidth', 2);
  xlim([0, 150*T]);
  title('Sinal Recebino no RX - Time Domain');
  grid on;

  subplot(412)
  plot(t_received, received_binary,  'LineWidth', 2);
  xlim([0, 150*T]);
  ylim([-0.1 1.2*max(received_binary)]);
  title('Sinal Filtrado no receptor - Time Domain');
  grid on;

  subplot(413)
  stem(t_received, received_binary,  'LineWidth', 2);
  xlim([0, 150*T]);
  title('Sinal Interpretado no receptor - Time Domain');
  grid on;


  subplot(414)
  plot(t,repeated_signal, 'LineWidth', 2);
  ylim([-0.2, 1.2]);
  xlim([0, 150*T]);
  xlabel('Time');
  ylabel('Amplitude');
  title('Sinal PCM Enviado por TX - Time Domain (Para Comparação)');
  grid on;

  % Vetor de tempo para o sinal recebido
  t_received = linspace(0, 1, length(received_signal));

  % Interpolando o sinal para restaurar a taxa de amostragem original
  received_signal_interp = interp(received_signal, n);

  % Filtrando o sinal interpolado para remover artefatos
  filtr_rx = ones(1, n);
  received_signal_filtered = filter(filtr_rx, 1, received_signal_interp) / n;

  % Convertendo o sinal recuperado para o formato analógico
  received_analog_signal = received_signal_filtered(1:length(t_received)) * (2*amplitude) - amplitude; % Normalização da amplitude

  % Plotando o sinal analógico recuperado
  figure(7)
  subplot(211);
  plot(tsine, signalsine, 'LineWidth', 2);
  xlim([0, 3*T]);
  xlabel('Tempo');
  ylabel('Amplitude');
  title('Sinal Analógico Recuperado');
  grid on;
  subplot(212);
  plot(tsine, received_signal_filtered(1:length(tsine)), 'LineWidth', 2);
  xlim([0, 3*T]);
  xlabel('Tempo');
  ylabel('Amplitude');
  title('Sinal Analógico Transmitido (Para comparação)');
  grid on;

