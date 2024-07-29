clc; clear all; close all
pkg load signal

% Definição dos parâmetros da portadora do sinal IQ:
carrier_amplitude = 1;
carrier_frequency = 50000;

% Coletando os sinais para transmissão:
[music_signal, Fs] = audioread('music.wav');
[suspense_signal, Fs2] = audioread('suspense.wav');

% Fazendo a transposição linha/coluna do sinal de entrada
music_signal = transpose(music_signal);
suspense_signal = transpose(suspense_signal);

% pegando a duração da transmissão a partir do tamanho do menor sinal;
duracao = length(music_signal)/Fs;

% calculando vetor de t no dominio do tempo;
Ts = 1/Fs;
t=[0:Ts:duracao-Ts];

% Igualando o comprimento dos sinais ao vetor de tempo
signal_cos = music_signal(1:length(t));
signal_sin = suspense_signal(1:length(t));

% calculando o passo no dominio da frequência;
f_step = 1/duracao;

% vetor "f" correspondente ao periodo de análise (dominio da frequência);
f = [-Fs/2:f_step:Fs/2];
f = [1:length(signal_cos)];

% calculando a FFT do sinal de entrada (que será utilizado no cosseno):
signal_cos_F = fft(signal_cos)/length(signal_cos);
signal_cos_F = fftshift(signal_cos_F);

% calculando a FFT do sinal de entrada (que será utilizado no seno):
signal_sin_F = fft(signal_sin)/length(signal_sin);
signal_sin_F = fftshift(signal_sin_F);

% Plot dos sinais de entrada (dominio do tempo e frequência):
figure(1)
subplot(221)
plot(t,signal_cos)
xlim([(duracao*0.3) (duracao*0.7)])
title('Audio 1 no domínio do tempo')
xlabel('Tempo (s)')
ylabel('Amplitude')

subplot(223)
plot(t,signal_sin)
xlim([(duracao*0.3) (duracao*0.7)])
title('Audio 2 no domínio do tempo')
xlabel('Tempo')
ylabel('Amplitude')

subplot(222)
plot(f,abs(signal_cos_F))
title('Audio 1 no domínio da frequência')
xlabel('Frequência')
ylabel('Magnitude')

subplot(224)
plot(f,abs(signal_sin_F))
title('Audio 2 no domínio da frequencia')
xlabel('Frequência')
ylabel('Magnitude')

% Criando dois sinais de portadora para transmissão ortogonal (um com seno e outro com cosseno):
carrier_cos = carrier_amplitude*cos(2*pi*carrier_frequency*t);
carrier_sin = carrier_amplitude* -sin(2*pi*carrier_frequency*t);

% Realizando a modulação AM do sinal de aúdio na portadora correspondente a cada sinal:
modulated_cos = signal_cos .* carrier_cos;
modulated_sin = signal_sin .* carrier_sin;

% Realizando a multiplexação do sinal (a partir do principio de ortogonalidade):
multiplexed_signal = modulated_cos + modulated_sin;

% Calculando a FFT do sinal para amostrar seu estado no dominio da frequência:
multiplexed_signal_F = fft(multiplexed_signal)/length(multiplexed_signal);
multiplexed_signal_F = fftshift(multiplexed_signal_F);

figure(2)
subplot(221)
plot(f,carrier_cos)
xlim([0 100*f_step])
title('Cosseno')
xlabel('Frequência')
ylabel('Magnitude')

subplot(223)
plot(f,carrier_sin)
xlim([0 100*f_step])
title('-Seno')
xlabel('Frequência')
ylabel('Magnitude')

subplot(222)
plot(t,modulated_cos)
xlim([(duracao*0.3) (duracao*0.7)])
title('Sinal em fase')
xlabel('Tempo')
ylabel('Amplitude')

subplot(224)
plot(t,modulated_sin)
xlim([(duracao*0.3) (duracao*0.7)])
title('Sinal em quadratura')
xlabel('Tempo')
ylabel('Amplitude')

% Verificando o sinal multiplexado:

figure(3)
subplot(211)
plot(t,multiplexed_signal)
xlim([(duracao*0.3) (duracao*0.7)])
title('Sinal modulado')
xlabel('Tempo')
ylabel('Amplitude')

subplot(212)
plot(f,abs(multiplexed_signal_F))
title('Sinal modulado no domínio da frequência')
xlabel('Frequência')
ylabel('Magnitude')

% Realizando a demodulação do sinal no receptor:

demodulated_cos = multiplexed_signal .* carrier_cos;
demodulated_sin = multiplexed_signal .* carrier_sin;

% Ordem do filtro FIR
filtro_ordem = 100;

% Frequência de corte do filtro FIR
% Como trata-se de um sinal de áudio, a frequência de corte pode ser fixada em 20kHz
frequencia_corte = 20000;

% Coeficientes do filtro FIR para cada sinal demodulado
coeficientes_filtro = fir1(filtro_ordem, frequencia_corte/(Fs/2));

% Resposta em frequência do filtro FIR para cada sinal demodulado
[H_cos, f_cos] = freqz(coeficientes_filtro, 1, length(t), Fs);
[H_sin, f_sin] = freqz(coeficientes_filtro, 1, length(t), Fs);


% Filtragem dos sinais demodulados
demodulated_cos_filtered = filter(coeficientes_filtro, 1, demodulated_cos);
demodulated_sin_filtered = filter(coeficientes_filtro, 1, demodulated_sin);

% Calculando a FFT dos sinais demodulados para amostrar seu estado no dominio da frequência:
demodulated_sin_F = fft(demodulated_sin_filtered)/length(demodulated_sin_filtered);
demodulated_sin_F = fftshift(demodulated_sin_F);

demodulated_cos_F = fft(demodulated_cos_filtered)/length(demodulated_cos_filtered);
demodulated_cos_F = fftshift(demodulated_cos_F);

% Plot dos sinais demodulados
figure(4)
subplot(211)
plot(t, demodulated_cos)
xlim([(duracao*0.3) (duracao*0.7)])
title('Sinal em fase')
xlabel('Tempo')
ylabel('Amplitude')

subplot(212)
plot(t, demodulated_sin)
xlim([(duracao*0.3) (duracao*0.7)])
title('Sinal em quadratura')
xlabel('Tempo')
ylabel('Amplitude')


% Plot dos sinais demodulados
figure(5)
subplot(221)
plot(t, demodulated_cos_filtered)
xlim([(duracao*0.3) (duracao*0.7)])
title('Áudio 1 demodulado no domínio do tempo')
xlabel('Tempo')
ylabel('Amplitude')

subplot(223)
plot(t, demodulated_sin_filtered)
xlim([(duracao*0.3) (duracao*0.7)])
title('Áudio 2 demodulado no domínio do tempo')
xlabel('Tempo')
ylabel('Amplitude')

subplot(222)
plot(f,abs(demodulated_cos_F))
title('Áudio 1 demodulado no domínio da frequência')
xlabel('Frequência')
ylabel('Magnitude')

subplot(224)
plot(f,abs(demodulated_sin_F))
title('Áudio 2 demodulado no domínio da frequência')
xlabel('Frequência')
ylabel('Magnitude')



