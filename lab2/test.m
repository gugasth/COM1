pkg load signal;
clc
clear all
close all



A1 = 2;
A2 = 2;
A3 = 2;

f1 = 1e3;
f2 = 2e3;
f3 = 3e3;

fs = 30*f3;
Ts = 1/fs;
T = 1/f1;

t_final = 2
t = [0:Ts:t_final];


passo_f = 1/t_final;
f = [-fs/2:passo_f:fs/2];

% Criando os sinais
x1_t = A1*cos(2*pi*f1*t);
x2_t = A2*cos(2*pi*f2*t);
x3_t = A3*cos(2*pi*f3*t);

x1_f = fft(x1_t)/length(x1_t);
x1_f = fftshift(x1_f);

x2_f = fft(x2_t)/length(x2_t);
x2_f = fftshift(x2_f);

x3_f = fft(x3_t)/length(x3_t);
x3_f = fftshift(x3_f);

% Portadoras
Ac = 1;
fc_1 = 10e3;
fc_2 = 12e3;
fc_3 = 14e3;

c1_t = Ac*cos(2*pi*fc_1*t);
c2_t = Ac*cos(2*pi*fc_2*t);
c3_t = Ac*cos(2*pi*fc_3*t);

s1_t = c1_t .* x1_t;
s1_f = fft(s1_t)/length(s1_t);
s1_f = fftshift(s1_f);

s2_t = c2_t .* x2_t;
s2_f = fft(s2_t)/length(s2_t);
s2_f = fftshift(s2_f);

s3_t = c3_t .* x3_t;
s3_f = fft(s3_t)/length(s3_t);
s3_f = fftshift(s3_f);

filtro_pb1 = [zeros(1, 71e3) ones(1,38001) zeros(1, 71e3)];
filtro_pb2 = [zeros(1, 69e3) ones(1,42001) zeros(1, 69e3)];
filtro_pb3 = [zeros(1, 67e3) ones(1,46001) zeros(1, 67e3)];

s1_pb_f = s1_f .* filtro_pb1;
s2_pb_f = s2_f .* filtro_pb2;
s3_pb_f = s3_f .* filtro_pb3;

y_f =  s1_pb_f + s2_pb_f + s3_pb_f;7

%filtro_pf = [zeros(1, 69e3) ones(1,42001) zeros(1, 69e3)];
%filtro_pa = [ones(1, 67e3) zero(1,46001) ones(1, 67e3)];


y1_f = y_f .* filtro_pb1 ;
%y2_f = .* filtro_pb1 ;
%y3_f = .* filtro_pb1 ;
%Subplot X3
subplot(3,2,5);
plot(t,x3_t,"b")
title("x_3(t)");
xlim([0 3*T])

y1_fs = ifftshift(y1_f);
y1_t = ifft(y1_fs)/length(y1_fs);
y1_t = c1_t .* y1_t;

filtro = fir1(50, (1000*2)/fs);
y1_t = filter(filtro, 1, y1_t);


y1_f = fft(y1_t)/length(y1_t);
y1_f = fftshift(y1_f);


% Plot no Dominio do tempo
% Subplot X1
figure(1)
subplot(3,2,1);
plot(t,x1_t,"r")
title("x_1(t)");
xlim([0 3*T])

subplot(3,2,2);
plot(f,abs(x1_f),"r")
title("X_1(f)");
xlim([-2*f3 2*f3])

%Subplot X2
subplot(3,2,3);
plot(t,x2_t,"g")
title("x_2(t)");
xlim([0 3*T])

subplot(3,2,4);
plot(f,abs(x2_f),"g")
title("X_2(f)");
xlim([-2*f3 2*f3])

%Subplot X3
subplot(3,2,5);
plot(t,x3_t,"b")
title("x_3(t)");
xlim([0 3*T])

subplot(3,2,6);
plot(f,abs(x3_f),"b")
title("X_1(f)");
xlim([-2*f3 2*f3])

figure(2)
subplot(311);
plot(f,abs(s1_f),"r")
title("S_1(f)");
xlim([-2*fc_3 2*fc_3])

subplot(312);
plot(f,abs(s2_f),"g")
title("S_2(f)");
xlim([-2*fc_3 2*fc_3])

subplot(313);
plot(f,abs(s3_f),"b")
title("S_3(f)");
xlim([-2*fc_3 2*fc_3])

figure(3)
%Filtros
subplot(3,1,1);
plot(f,filtro_pb1,"r");
ylim([0 1.2]);
title("Filtro Passa Baixa 2kHz");

subplot(3,1,2);
plot(f,filtro_pb2,"g");
ylim([0 1.2]);
title("Filtro Passa Alta 4kHz");


subplot(3,1,3);
plot(f,filtro_pb3,"b");
ylim([0 1.2]);
title("Filtro Passa Faixa 2kHz-4kHz");

figure(4)
subplot(311);
plot(f,abs(s1_pb_f),"r")
title("S_1(f)");
xlim([-2*fc_3 2*fc_3])
%Subplot X3
subplot(3,2,5);
plot(t,x3_t,"b")
title("x_3(t)");
xlim([0 3*T])
subplot(312);
plot(f,abs(s2_pb_f),"g")
title("S_2(f)");
xlim([-2*fc_3 2*fc_3])

subplot(313);
plot(f,abs(s3_pb_f),"b")
title("S_3(f)");
xlim([-2*fc_3 2*fc_3])

figure(5)
plot(f,abs(y_f))
xlim([-2*fc_3 2*fc_3])

figure(6)
subplot(211)
plot(f,abs(y1_f))
xlim([-2*fc_3 2*fc_3])
subplot(212)
plot(t,y1_t,"b")
title("x_3(t)");
xlim([0 3*T])