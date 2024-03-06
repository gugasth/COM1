# Aula realizada dia 06 de março de 2024
# Aluno: Gustavo Paulo

clear all; close all; clc;
pkg load signal;

fs = 2e5;
ts = 1/fs;

fc = 1e3;
A1 = 1;

fm = 10e3;
A2 = 1;

m = 0.5;
Ac = 1;
Ao = 5;

t = [0 : ts : 1];

m_t = cos(2*pi*fm*t);
c_t = Ac .* cos(2*pi*fc*t);
s_t = Ao .*(1 + (m*m_t)) .* c_t;

passo_f = 1;
f = [-fs/2 : passo_f : fs/2];

M_f = fftshift(fft(m_t) / length(m_t));
C_f = fftshift(fft(c_t) / length(c_t));
S_f = fftshift(fft(s_t) / length(s_t));

figure(1)
subplot(311)
plot(t, m_t)
xlim([0 15*(1/fm)])
subplot(312)
plot(t, c_t)
xlim([0 15*(1/fm)])
subplot(313)
plot(t, s_t)
xlim([0 15*(1/fm)])

figure(2)
subplot(311)
plot(f, abs(M_f))
suibplot(312)
