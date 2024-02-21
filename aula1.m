clc
clear all
close all

A1 = 10;
A2 = 1;
A3 = 4;

f1 = 100;
f2 = 200;
f3 = 300;

fs = 50*f2;
Ts = 1/fs;
T = 1/f1;
t_final = 2
t = [0:Ts:t_final];
x1_t = A1*cos(2*pi*f1*t);
x2_t = A2*cos(2*pi*f2*t);
x3_t = A3*cos(2*pi*f3*t);


x_t = x1_t + x2_t + x3_t;

X_f = fft(x_t)/length(x_t);
X_f = fftshift(X_f);
passo_f = 1/t_final;
f = [-fs/2:passo_f:fs/2];

figure(1)
plot(t,x_t)
xlim([0 3*T])

figure(2)
plot(f,abs(X_f))
grid on
