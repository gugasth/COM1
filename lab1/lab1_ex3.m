# Laboratório 1 de Sistemas de Comunicação I
# Aluno: Gustavo Paulo

clear all;
clc;
close all;

fs = 10000;

# Exercício 1
ruido = randn(1, fs);

# Exercício 2
figure (1)
hist(ruido, bins=50)
title ('Histograma do ruído')
t = [1/fs : 1/fs : 1];

# Exercício 3
### Domínio do tempo
figure (2)
plot (t, ruido)
title ('Ruído no domínio do tempo')

### Domínio da frequência
fs = 10000;
aux = -fs/2 + 1;
aux2 = fs/2;
f = [aux : 1 : aux2];
Ruido_f=fft (ruido) /length(ruido);
Ruido_f = fftshift (Ruido_f);
figure (3)
plot (f, abs(Ruido_f))
title ('Ruído no domínio da frequencia')

# Exercício 4
aux = -fs+1;
aux2 = fs-1;
t2=[aux : 1 : aux2];
figure (4)
plot (t2 , xcorr(ruido))
title ('Autocorrelação do ruído')

# Exercício 5
filtro = fir1 (50,(1000*2)/fs);
figure (5)
freqz(filtro)
title ('Resposta em frequência do filtro')

# Exercício 6
### Domínio do tempo
saida_t = filter ( filtro ,1, ruido) ;
figure (6)
plot ( t ,saida_t)
title ('Ruído filtrado no tempo')

### Domínio da frequência
saida_f = fft (saida_t) / length(saida_t) ;
saida_f = fftshift (saida_f) ;
figure (7)
plot (f, abs(saida_f))
title ('Ruído filtrado na frequência')

### Histograma final
figure(8)
hist(saida_t, bins=50)
title('Histograma do sinal filtrado')
