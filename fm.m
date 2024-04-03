kf = 75e3;  % Sensibilidade de frequência
Am = 1;  % Amplitude da mensagem
fm = 10e3;  % Frequência da mensagem
Ac = 1;  % Amplitude da portadora
fc = 150e3;  % Frequência da portadora

delta_f = kf * Am;  % Desvio de frequência
beta = delta_f / fm;  % Índice de modulação

fs = 50 * fc;  % Frequência de amostragem
Ts = 1 / fs;  % Período de amostragem
T = 1 / fm;  % Período da mensagem
t = 0:Ts:1-Ts;  % Eixo do tempo

m_t = cos(2 * pi * fm * t);  % Sinal mensagem
c_t = cos(2 * pi * fc * t);  % Sinal portadora
s_t = Ac * cos(2 * pi * fc * t + beta * sin(2 * pi * fm * t));  % Sinal modulado

subplot(3, 1, 1);
plot(t, m_t);
xlim([0, T * 5]);
title("Message Signal");
xlabel("Time (s)");
ylabel("Amplitude");

subplot(3, 1, 2);
plot(t, c_t);
xlim([0, T * 5]);
title("Carrier Signal");
xlabel("Time (s)");
ylabel("Amplitude");

subplot(3, 1, 3);
plot(t, s_t);
xlim([0, T * 5]);
title("FM Signal");
xlabel("Time (s)");
ylabel("Amplitude");

