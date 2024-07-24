clear all; close all; clc;

pkg load communications

% Definir faixa de SNR em dB
SNR_dB = -40:2:40; % Exemplo: de -10 dB a 20 dB, com incremento de 2 dB

% Número de bits por constelação MQAM
numBits_per_M = 100;

% Inicializar vetores para armazenar BER para cada M
M_values = [4, 16, 64];
ber = zeros(length(M_values), length(SNR_dB));


for m = 1:length(M_values)
    M = M_values(m);
    k = log2(M); % Bits por símbolo

    for i = 1:length(SNR_dB)
        % Gerar bits aleatórios para cada iteração de SNR e para cada M
        bits = randi([0 1], numBits_per_M * k, 1);

        % Reshape para dividir em símbolos
        symbols = bi2de(reshape(bits, k, [])');

        % Modulação QAM
        constellation = qammod(symbols, M);

        % Potência do ruído
        SNR_linear = 10^(SNR_dB(i) / 10);
        noisePower = 1 / SNR_linear;

        % Ruído AWGN
        noise = sqrt(noisePower) * randn(size(constellation));
        receivedSignal = constellation + noise;

        % Demodulação QAM
        demodulatedSymbols = qamdemod(receivedSignal, M);
        receivedBits = de2bi(demodulatedSymbols, k);
        receivedBits = receivedBits(:);

        % Calcular BER
        ber(m, i) = biterr(bits, receivedBits) / (numBits_per_M * k);
    end
end


% Plotar o gráfico log(BER) vs SNR
figure;
semilogy(SNR_dB, ber(1,:), '-o', 'DisplayName', 'M = 4');
hold on;
semilogy(SNR_dB, ber(2,:), '-s', 'DisplayName', 'M = 16');
semilogy(SNR_dB, ber(3,:), '-^', 'DisplayName', 'M = 64');
hold off;
grid on;
xlabel('SNR (dB)');
ylabel('BER');
title('Bit Error Rate (BER) vs Signal-to-Noise Ratio (SNR) for MQAM');
legend('show');

