# Aula realizada dia 05 de março de 2024
# Aluno: Gustavo Paulo
# Modulação e demodulação AM

clear all; close all; clc;
pkg load signal;

fs = 1e5;
ts = 1/fs;

f1 = 1e3;
A1 = 1;

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

f_cut = 2e3;
filtro_pb = [zeros(1, fs/2 - f_cut/2) ones(1, f_cut + 1) zeros(1, fs/2 - f_cut/2)];

M_f_hat = 2 * R_f .* filtro_pb;
m_t_hat = ifft(ifftshift(M_f_hat)) * length(M_f_hat);

figure(1)
subplot(5, 2, 1)
plot(t, m_t)
xlim([0 5*(1/f1)])

subplot(5, 2, 3)
plot(t, c_t)
xlim([0 5*(1/f1)])

subplot(5, 2, 5)
plot(t, s_t)
xlim([0 5*(1/f1)])

subplot(5, 2, 7)
plot(t, r_t)
xlim([0 5*(1/f1)])

subplot(5, 2, 9)
plot(f, abs(M_f))
xlim([-4*f2 4*f2])

subplot(5, 2, 2)
plot(f, abs(M_f))
xlim([-4*f2 4*f2])

subplot(5, 2, 4)
plot(f, abs(C_f))
xlim([-4*f2 4*f2])

subplot(5, 2, 6)
plot(f, abs(S_f))
xlim([-4*f2 4*f2])

subplot(5, 2, 8)
plot(f, abs(R_f))
xlim([-4*f2 4*f2])

subplot(5, 2, 10)
plot(f, abs(M_f_hat))
xlim([-4*f2 4*f2])