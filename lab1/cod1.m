# Laboratório 1 de Sistemas de Comunicação I
# Aluno: Gustavo Paulo

pkg load signal

clear all;
clc;
close all;

fs = 100e3;
f1 = 1e3;
f2 = 3e3;
f3 = 5e3;
A1 = 6;
A2 = 2;
A3 = 4;
ts = 1e-5
t = [0:ts:1];
x1_t = A1 * sin(2*pi*f1*t);
x2_t = A2 * sin(2*pi*f2*t);
x3_t = A3 * sin(2*pi*f3*t);
s_t = x1_t + x2_t + x3_t;

passo_f = 1;
f = [-fs/2: passo_f: fs/2];
S_f = fftshift(fft(s_t) / length(s_t));
x1_f = fftshift(fft(x1_t) / length(x1_t));
x2_f = fftshift(fft(x2_t) / length(x2_t));
x3_f = fftshift(fft(x3_t) / length(x3_t));

# tem que ser 0 as primeiras -48000, dps ser 1, dps voltar a ser 0, pra formar o filtro
filtro_PB_f = [zeros(1, 48000) ones(1, 4001) zeros(1, 48000)];
ordem = 50;
f_cut = 1400;
filtro_PB_t = fir1(ordem, (f_cut*2)/fs);

Y_f = abs(S_f) .* filtro_PB_f; # abs pra garantir que está sempre pegando o módulo e não a fase

y_t = ifft(ifftshift(Y_f)) * length(Y_f); # fazer a inversa
y1_t = filter(filtro_PB_t, 1, s_t);

# figura 1 ---------------------------
figure(1)
subplot(2, 2, 1)
plot(t, s_t)
xlim([0 5*(1/f1)])

subplot(2, 2, 2)
plot(t, x1_t)
xlim([0 5*(1/f1)])

subplot(2, 2, 3)
plot(t, x2_t)
xlim([0 5*(1/f1)])


subplot(2, 2, 4)
plot(t, x3_t)
xlim([0 5*(1/f1)])

# ------------------------------------
# figura 2 ---------------------------
figure(2)
subplot(2, 2, 1)
plot(f, abs(S_f));

subplot(2, 2, 2)
plot(f, abs(x1_f))

subplot(2, 2, 3)
plot(f, abs(x2_f))

subplot(2, 2, 4)
plot(f, abs(x3_f))
#ylim([0 1.2])

#subplot(3, 1, 3)
#plot(f, Y_f)
# ------------------------------------
# figura 3 ---------------------------
pot_media = (norm(s_t).^2) / length(s_t) # potencia média

figure(3)
pwelch(s_t)
