  close all; clear all; clc;
  pkg load signal;
  pkg load communications;

  % Defining the base signal amplitude.
  A_signal = 1;

  % Defining the frequency for the base signal
  f_signal = 50000;

  % Defining the period and frequency of sampling:
  fs = 40*f_signal;
  Ts = 1/fs;
  T = 1/f_signal;

  % Defining the sinal period.
  t_inicial = 0;
  t_final = 0.01;

  % "t" vector, correspondig to the time period of analysis, on time domain.
  t = [t_inicial:Ts:t_final];
  tsine = t;

  signal = A_signal*sin(2*pi*f_signal*t);

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

  figure(1)
  subplot(411)
  plot(t,signal)
  grid on;
  xlim([0 10*T])
  title('Sinal analógico de informação')

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


  subplot(412)
  plot(t_super,filtered_signal);
  xlim([0, 55*T]);
  ylim([-amplitude*1.1 , amplitude*1.1]);
  xlabel('Tempo');
  ylabel('Amplitude');
  title('Sinal Binário pós superamostrar e quantizar');



  subplot(413)
  plot(t_super,transmission_noise);
  xlim([0, 15*T]);
  ylim([-amplitude*1.1 , amplitude*1.1]);
  xlabel('Tempo');
  ylabel('Amplitude');
  title('Ruído AWGN');



  subplot(414)
  plot(t_super,transmitted_signal);
  xlim([0, 55*T]);
  ylim([-amplitude*1.1 , amplitude*1.1]);
  xlabel('Tempo');
  ylabel('Amplitude');
  title('Sinal Transmitido');
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

  subplot(211)
  plot(t_received, received_signal);
  xlim([0, 50*T]);
  title('Sinal Recebido no domínio do tempo');
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
  subplot(212);
  plot(tsine, signalsine);
  xlim([0, 10*T]);
  xlabel('Tempo');
  ylabel('Amplitude');
  title('Sinal Recuperado');

