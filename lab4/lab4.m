pkg load signal
fc = 100e3;  % Frequência da portadora
kf = 75e3;  % Sensibilidade de frequência
Am = 1;  % Amplitude da mensagem
fm = 10e3;  % Frequência da mensagem
Ac = 1;  % Amplitude da portadora
fs = 50 * fc;  % Frequência de amostragem

delta_f = kf * Am;  % Desvio de frequência
beta = delta_f / fm;  % Índice de modulação
Ts = 1 / fs;  % Período de amostragem
T = 1 / fm;  % Período da mensagem
t = 0:Ts:1-Ts;  % Eixo do tempo

m_t = cos(2 * pi * fm * t);  % Sinal mensagem
c_t = cos(2 * pi * fc * t);  % Sinal portadora
s_t = Ac * cos(2 * pi * fc * t + beta * m_t);  % Sinal modulado


% Transformada de Fourier dos sinais
M_t = fftshift(fft(m_t));
C_t = fftshift(fft(c_t));
S_t = fftshift(fft(s_t));
Demodulated_signal = fftshift(fft(demodulated_signal));
Envelope_signal_filtrado = fftshift(fft(envelope_signal_filtrado));

% Eixo da frequência
f = linspace(-fs/2, fs/2, length(t));

% Plot dos sinais no domínio do tempo e da frequência
figure(1)
subplot(2, 2, 1);
plot(t, m_t);
title("Sinal de mensagem - Tempo");
xlabel("Tempo (segundos)");
ylabel("Amplitude");
xlim([0, T * 5]);

subplot(2, 2, 2);
plot(f, abs(M_t));
title("Sinal de mensagem - Frequência");
xlabel("Frequência (Hz)");
ylabel("Magnitude");
xlim([0 20e4]);


subplot(2, 2, 3);
plot(t, c_t);
title("Sinal da portadora - Tempo");
xlabel("Tempo (segundos)");
ylabel("Amplitude");
xlim([0, T * 5]);

subplot(2, 2, 4);
plot(f, abs(C_t));
title("Sinal da portadora - Frequência");
xlabel("Frequência (Hz)");
ylabel("Magnitude");
xlim([0 20e4]);

figure(2)
subplot(2, 1, 1);
plot(t, s_t);
title("Sinal FM - Tempo");
xlabel("Tempo (segundos)");
ylabel("Amplitude");
xlim([0, T * 5]);

subplot(2, 1, 2);
plot(f, abs(S_t));
title("Sinal FM - Frequência");
xlabel("Frequência (Hz)");
ylabel("Magnitude");
xlim([0 20e4]);

figure(3)
subplot(2, 1, 1);
plot(t, demodulated_signal);
title("Sinal Demodulado - Tempo");
xlabel("Tempo (segundos)");
ylabel("Amplitude");
xlim([0, T * 5]);

subplot(2, 1, 2);
plot(f, abs(Demodulated_signal));
title("Sinal Demodulado - Frequência");
xlabel("Frequência (Hz)");
ylabel("Magnitude");
xlim([0 20e4]);

figure(4)
subplot(2, 1, 1);
plot(t, envelope_signal_filtrado);
title("Envelope do Sinal Demodulado - Tempo");
xlabel("Tempo (segundos)");
ylabel("Amplitude");
xlim([0, T * 5]);

subplot(2, 1, 2);
plot(f, abs(Envelope_signal_filtrado));
title("Envelope do Sinal Demodulado - Frequência");
xlabel("Frequência (Hz)");
ylabel("Magnitude");
xlim([0 20e4]);
