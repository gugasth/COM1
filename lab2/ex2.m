% Laboratório 2 de Sistemas de Comunicação I
# Aluno: Gustavo Paulo

pkg load signal

clear all
close all
clc

Am = 1;
Ac = 1;
u = 1;

fm = 1e3;
fc = 1e3;
fa = 100e3;
Ta = 1/fa;
t_final = 1000*(1/fm);
t = [0: Ta: t_final];

m1_t_default = Am*cos(2*pi*1*fm*t);
m2_t_default = Am*cos(2*pi*2*fm*t);
m3_t_default = Am*cos(2*pi*3*fm*t);

c1_t = Ac*cos(2*pi*10*fc*t) ;
c2_t = Ac*cos(2*pi*12*fc*t) ;
c3_t = Ac*cos(2*pi*14*fc*t) ;

% Modulacao
m1_t = (m1_t_default) .* c1_t;
m2_t = (m2_t_default) .* c2_t;
m3_t = (m3_t_default) .* c3_t;

% Filtragem dos sinais
filtro_m1 = fir1 (100, (9000)*2/fa) ;
filtro_m2 = fir1 (100, (10000)*2/fa) ;
filtro_m3 = fir1 (100, (11000)*2/fa) ;

# Realiza a filtragem
m1_t = filter (filtro_m1 ,1, m1_t);
m2_t = filter (filtro_m2 ,1, m2_t);
m3_t = filter (filtro_m3 ,1, m3_t);

% Multiplexacao
mult = m1_t + m2_t + m3_t;

passo_f = 1/t_final;
f = [-fa /2: passo_f:fa/2];

# fig 1 --------------------
figure (1)
subplot(321)
plot (f, abs(fftshift(fft(m1_t_default))))
title ('Sinal de 1kHZ')
xlim([-5000 5000])

subplot(323)
plot (f, abs(fftshift(fft (m2_t_default))))
title ('Sinal de 2kHZ')
xlim([-5000 5000])

subplot(325)
plot (f, abs(fftshift(fft(m3_t_default))))
title ('Sinal de 3kHZ')
xlim([-5000 5000])

subplot(322)
plot (f, abs(fftshift(fft(m1_t))))
title ('Sinal de 1kHZ modulado')
xlim([-10000 10000])

subplot(324)
plot (f, abs(fftshift(fft(m2_t))))
title ('Sinal de 2kHZ modulado')
xlim([-11000 11000])

subplot(326)
plot (f, abs(fftshift(fft(m3_t))))
title ('Sinal de 3kHZ modulado')
xlim([-15000 15000])
#---------------------------

# fig 2 --------------------
figure(2)
plot ( f ,abs( fftshift ( fft (mult)) ) )
title ('Sinal multiplexado' )
xlim([-15000 15000])
#---------------------------



# fig 3 --------------------
% Demodulação do sinal 1
filtro_sinal1 = fir1 (150, (9000*2)/fa) ;
r1_t = filter(filtro_sinal1 ,1, mult) ;
figure (3)
subplot(321)
plot ( f ,abs( fftshift ( fft (r1_t) ) ) )
title ('Sinal de 1kHZ filtrado')
xlim([-13000 13000])

r1_t = r1_t .* c1_t;
r1_t = filter ( fir1 (50,(1010*2)/fa ) ,1, r1_t) ;
subplot(322)
plot ( f, abs( fftshift ( fft (r1_t) ) ) )
title ('Sinal de 1kHZ demodulado')
xlim([-5000 5000])

% Demodulação do sinal 2
filtro_sinal2 = fir1 (150, [(9991*2)/ fa (10001*2)/fa ]) ;
r2_t = filter(filtro_sinal2, 1, mult) ;
subplot(323)
plot (f, abs( fftshift ( fft (r2_t) ) ) )
title ('Sinal de 2kHZ filtrado')
xlim([-13000 13000])

r2_t = r2_t .* c2_t;
r2_t = filter(fir1(50,(2010*2)/fa) ,1, r2_t) ;
subplot(324)
plot ( f ,abs( fftshift ( fft (r2_t) ) ) )
title ('Sinal de 2kHZ demodulado')
xlim([-5000 5000])

% Demodulação do sinal 3
filtro_sinal3 = fir1 (150, (10990*2)/fa, 'high' ) ;
r3_t = filter (filtro_sinal3 ,1, mult) ;
subplot(325)
plot (f ,abs( fftshift ( fft (r3_t) ) ) )
title ('Sinal de 3kHZ filtrado ' )
xlim([-13000 13000])

r3_t = r3_t .* c3_t;
r3_t = filter ( fir1 (50,(3010*2)/fa ) ,1, r3_t) ;
subplot(326)
plot (f, abs(fftshift(fft(r3_t))))
title ('Sinal de 3kHZ demodulado')
xlim([-5000 5000])
