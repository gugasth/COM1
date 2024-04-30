pkg load signal
pkg load communications

clc
close all
clear all

N = 1000;
limiar = 0;
A = 1;
ts = 1e-6;
t = [0:ts:1];
t(end) = [];

filtro_tx = ones(1, N);
filtro_rx = fliplr(filtro_tx);
info = randi([0 1], 1, 1000);
info_up = upsample(info, N) * (2*A) - A; % NRZ
s_t = filter(filtro_tx, 1, info_up);

for snr = 1:15
  r_t = awgn(s_t, snr, 'measured');
  rt_filter = filter(filtro_rx, 1, r_t);
  z_t = rt_filter(N:end); % Corrigindo a extração do sinal demodulado
  info_demod = z_t(1:length(info_up)) > limiar; % Demodulação
  [num_erro, taxa_erro] = biterr(info_up, info_demod); % Avaliando o erro de bit
endfor


# Figure 1
figure(1)
subplot(221)
plot(filtro_tx)
title('Filtro tx')

subplot(222)
plot(filtro_rx)
title('Filtro rx')

subplot(223)
plot(t, s_t)
title('s_t')

subplot(224)
plot(t, info_up)
title('Infomação pós upsample')

# Figure 2
figure(2)
subplot(221)
plot(t, r_t)
title('r_t')

subplot(222)
semilogy(z_t)
title('z_t')

subplot(223)
semilogy(info_demod)
title('Informação demodulada')
