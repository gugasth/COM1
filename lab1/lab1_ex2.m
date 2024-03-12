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
A1 = 5;
A2 = 5/3;
A3 = 1;
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
Y_f = S_f;
y_t = s_t;

% passa baixas
filtro_PB_f = [zeros(1, 48000) ones(1,4001) zeros(1,48000)];

% passa altas
filtro_PA_f = [ones(1,46000) zeros(1,8001) ones(1,46000)];

% passa faixa
filtro_PF_f = [zeros(1, 46000) ones(1,2000) zeros(1,4001) ones(1,2000) zeros(1, 46000)];

% Filtragem na frequencia PBx
Y_f_filtrado_PBx = abs(Y_f) .* filtro_PB_f ;
PB_t = ifftshift (Y_f_filtrado_PBx);
PB_t = ifft (PB_t).*length(y_t) ;

% Filtragem na frequencia PA
Y_f_filtrado_PA = abs(Y_f) .* filtro_PA_f ;
PA_t = ifftshift (Y_f_filtrado_PA) ;
PA_t = ifft (PA_t).* length(y_t) ;

% Filtragem na frequencia PF
Y_f_filtrado_PF = abs(Y_f) .* filtro_PF_f ;
PF_t = ifftshift (Y_f_filtrado_PF);
PF_t = ifft (PF_t).*length(y_t) ;


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
figure (3)
subplot(311)
plot (f, filtro_PB_f )
title ('Filtro passa baixas')
subplot(312)
plot (f, filtro_PA_f )
title ('Filtro passa altas')
subplot(313)
plot (f, filtro_PF_f )
title ('Filtro passa faixa')

# ------------------------------------
# figura 4 ---------------------------
figure (4)
subplot(311)
plot (t, PB_t)
title ('Sinal filtrado PB no tempo')
xlim ([0 0.002])
subplot(312)
plot (t ,PA_t)
title ('Sinal filtrado PA no tempo')
xlim ([0 0.002])
subplot(313)
plot (t,PF_t)
title ('Sinal filtrado PF no tempo')
xlim ([0 0.002])


# ------------------------------------
# figura 5 ---------------------------
figure (5)
subplot(311)
plot (f, Y_f_filtrado_PBx)
title ('Sinal filtrado PB na frequência')
subplot(312)
plot (f, Y_f_filtrado_PA)
title ('Sinal filtrado PA na frequência')
subplot(313)
plot (f, Y_f_filtrado_PF)
title ('Sinal filtrado PF na frequência')
