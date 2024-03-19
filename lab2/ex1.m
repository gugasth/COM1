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
fc = 50e3;
fa = 200e3;
Ta = 1/fa ;
t_final = 1000*(1/fm);

t = [0: Ta: t_final ];
m_t = Am *cos(2 *pi *fm* t);
c_t = Ac *cos(2 *pi *fc* t );
figure (1)
subplot(211)
plot ( t ,m_t)
title ( ' Sinal original ' )
ylim([-(Am)*1.2 (Am)*1.2])
xlim ([0 10*(1/fm)])
subplot(212)
plot ( t ,c_t)
title ( ' Sinal da portadora')
ylim ([-( Am )*1.2 (Am)*1.2])
xlim ([0 2*(1/fm)])


%modulacao AM DSB SC
s_t_DSB_SC = (m_t) .* c_t;
passo_f = 1/ t_final ;
f = [-fa /2: passo_f:fa /2];
figure (2)
plot (t, s_t_DSB_SC)
title('Modulação AM DSB SC')
ylim ([-( Am )* 1.2 (Am)* 1.2])
xlim ([0 3*(1/fm)])

hold on
plot (t, m_t)

%demodulacao am dsb sc
sc_demod_t = (s_t_DSB_SC).*c_t;
filtro_PB = fir1(50,(1500*2)/fa);
sc_demod_filtrado_t = filter ( filtro_PB , 1, sc_demod_t);
sc_demod_filtrado_f = ifftshift ( ifft (sc_demod_filtrado_t));
figure (3)
subplot(212)
plot (f, abs(sc_demod_filtrado_f))
title ('Sinal demodulado na frequencia')
subplot(211)
plot (t, sc_demod_filtrado_t)
title ('Sinal demodulado no tempo')
ylim ([-( Am )*1.2 (Am)*1.2])
xlim ([0 10*(1/fm)])


%sinal am dsb
%u = 0.25
figure (4)

u =0.25;
Ao = u*Am;
s_t_DSB = (m_t+Ao) .* c_t;
subplot(321)
plot ( t ,s_t_DSB)
title ( 'Fator 0.25' )
ylim ([-( Am +Ao)*1.3 (Am+Ao)*1.2])
xlim ([0 3*(1/fm)])
hold on
plot ( t ,m_t+Ao)
hold off
%u = 0.50
u =0.5;
Ao = u*Am;

s_t_DSB = (m_t+Ao) .* c_t;
subplot(322)
plot ( t ,s_t_DSB)
title ( 'Fator 0.50' )
ylim ([-( Am +Ao)*1.3 (Am+Ao)*1.2])
xlim ([0 3*(1/fm)])
hold on
plot ( t ,m_t+Ao)
hold off
%u = 0.75
u =0.75;
Ao = u*Am;
s_t_DSB = (m_t+Ao) .* c_t;
subplot(323)
plot ( t ,s_t_DSB)
title ( 'Fator 0.75' )
ylim ([-( Am +Ao)*1.3 (Am+Ao)*1.2])
xlim ([0 3*(1/fm)])

hold on
plot ( t ,m_t+Ao)
hold off
%u = 1
u =1;
Ao = u*Am;
s_t_DSB = (m_t+Ao) .* c_t;
subplot(324)
plot ( t ,s_t_DSB)
title ('Fator 1' )

ylim ([-( Am +Ao)*1.3 (Am+Ao)*1.2])
xlim ([0 3*(1/fm)])
hold on

plot ( t ,m_t+Ao)
hold off
%u = 1.50
u =1.5;
Ao = u*Am;
s_t_DSB = (m_t+Ao) .* c_t;
subplot(325)
plot ( t ,s_t_DSB)
title ('Fator 1.5 ' )
ylim ([-( Am +Ao)*1.3 (Am+Ao)*1.2])
xlim ([0 3*(1/fm)])
hold on

plot ( t ,m_t+Ao)
hold off