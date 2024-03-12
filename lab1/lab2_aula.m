clear all; close all; clc;
pkg load signal;

fs = 1e5;
ts = 1/fs;

f1 = 1e3;
A1 = 3;

f2 = 10e3;
A2 = 1;


t = [0 : ts : 1];
m_t = A1 * cos(2*pi*f1*t);
c_t = A2 * cos(2*pi*f2*t);
s_t = m_t .* c_t;
r_t = s_t .* c_t;

passo_f = 1;
f = [-fs/2 : passo_f : fs/2];
M_f = fftshift(fft(m_t) / length(m_t));
C_f = fftshift(fft(c_t) / length(c_t));
S_f = fftshift(fft(s_t) / length(s_t));
R_f = fftshift(fft(r_t) / length(r_t));

ordem_filtro = 10; % Ordem do filtro FIR
coeficientes_filtro = fir1(ordem_filtro, [1000 3000] * 2/fs); % Projeta o filtro passa-baixa

m_t_hat = filter(coeficientes_filtro, 1, r_t); % Filtra o sinal modulado para demodulação
m_f_hat = fftshift(fft(m_t_hat) / length(m_t_hat));

figure(1)
subplot(4, 1, 1)
plot(t, m_t)
xlim([0 5*(1/f1)])
title('Sinal Modulante')

subplot(4, 1, 2)
plot(t, c_t)
xlim([0 5*(1/f1)])
title('Portadora')

subplot(4, 1, 3)
plot(t, r_t)
xlim([0 5*(1/f1)])
title('Sinal Modulado')

subplot(4, 1, 4)
plot(t, m_t_hat)
xlim([0 5*(1/f1)])
title('Sinal Demodulado')
xlabel('Tempo (s)')


figure(2)
subplot(4, 1, 1)
plot(f, abs(M_f))
xlim([-10000 10000])
title('Sinal Modulante')

subplot(4, 1, 2)
plot(f, abs(C_f))
xlim([-100000 100000])
title('Portadora')

subplot(4, 1, 3)
plot(f, abs(R_f))
xlim([-10000 10000])
title('Sinal Modulado')

subplot(4, 1, 4)
plot(f, abs(m_f_hat))
xlim([-10000 10000])
title('Sinal Demodulado')

xlabel('Tempo (s)')
