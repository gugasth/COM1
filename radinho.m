filename = 'gqrx_20240327_110612_100900000_1800000_fc.raw';
fileID = fopen(filename, 'rb');
dataIQ = fread(fileID, [2, Inf], 'float32');
fclose(fileID);
I = dataIQ(1,:);
Q = dataIQ(2,:);

C = I + 1i * Q;

fs = 1.8e9;

N = length(C);

frequencies = (-N/2 : N/2-1) * fs / N;

plot(frequencies, abs(fftshift(fft(C))));
xlabel('Frequência (Hz)');
title('FFT do sinal');
