
pkg load communications

A_c = 1
A=5;
N=100;
M=2;
Rb = 1e3;
Tb = 1/Rb;
Fs = Rb*N;

# Garantir que fs > 2*fc
fc=Fs/50;

N_periodos_c = N/(Fs / fc)

Ts=1/Fs;
t = [0: Ts: 1-Ts];
filtro_NRZ = ones(1,N);
info = randi([0 M-1],1,Rb);
info_up = upsample(info, N);
sinal_tx = filter(filtro_NRZ, 1, info_up)*1;

x_psk = A*sin(2*pi*fc*t + (2*pi*sinal_tx/M));
x_ask = A_c*sinal_tx .*sin(2*pi*fc*t);
x_fsk = A_c*sin(2*pi*fc*(sinal_tx+1).*t);

subplot(411)
plot(t, sinal_tx)
xlim([0 10*Tb])

subplot(412)
plot(t, x_psk)
xlim([0 10*Tb])

subplot(413)
plot(t, x_ask)
xlim([0 10*Tb])

subplot(414)
plot(t, x_fsk)
xlim([0 10*Tb])

