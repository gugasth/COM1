# Aula realizada dia 05 de março de 2024
# Aluno: Gustavo Paulo
# Modulação AM

pkg load signal

clear all;
clc;
close all;

fs = 1e5;
fm = 1e3;
fc = 10e3;
AM = 1;
AC = 1;
ts = 1/fs
t = [0:ts:1];
x1_t = AM * cos(2*pi*fm*t);
x2_t = AC * cos(2*pi*fc*t);
s_t = x1_t .* x2_t;

passo_f = 1;
f = [-fs/2: passo_f: fs/2];
S_f = fftshift(fft(s_t) / length(s_t));


figure(1)
subplot(2, 1, 1)
plot(t, s_t)
title('S(t) no tempo')
xlim([0 5*(1/fm)])
subplot(2, 1, 2)
plot(f, abs(S_f))
title('S(f) na frequência')

figure(2)
subplot(411)

