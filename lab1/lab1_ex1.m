# Laboratório 1 de Sistemas de Comunicação I
# Aluno: Gustavo Paulo

pkg load signal

clear all;
clc;
close all;

fs = 1e5;
f1 = 1e3;
f2 = 3e3;
f3 = 5e3;
A1 = 6;
A2 = 2;
A3 = 4;
ts = 1/fs
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


# figura 1 ---------------------------
figure(1)
subplot(2, 2, 1)
plot(t, s_t)
title('s_t')
xlim([0 5*(1/f1)])

subplot(2, 2, 2)
plot(t, x1_t)
title('x1_t')
xlim([0 5*(1/f1)])

subplot(2, 2, 3)
plot(t, x2_t)
title('x2_t')
xlim([0 5*(1/f1)])


subplot(2, 2, 4)
plot(t, x3_t)
title('x3_t')
xlim([0 5*(1/f1)])

# ------------------------------------
# figura 2 ---------------------------
figure(2)
subplot(2, 2, 1)
plot(f, abs(S_f));
xlim([-4*f2 4*f2])
title('S_f')


subplot(2, 2, 2)
plot(f, abs(x1_f))
xlim([-4*f2 4*f2])
title('x1_f')

subplot(2, 2, 3)
plot(f, abs(x2_f))
xlim([-4*f2 4*f2])
title('x2_f')

subplot(2, 2, 4)
plot(f, abs(x3_f))
xlim([-4*f2 4*f2])
title('x3_f')

# ------------------------------------
# figura 3 ---------------------------
pot_media = (norm(s_t).^2) / length(s_t) # potencia média

figure(3)
pwelch(s_t, [],[],[], fs)
xlim([0 10000])
