pkg load communications;

clc; clear all; close all;

% Função para calcular o BER
function ber = compute_ber(original_data, demodulated_data)
  errors = sum(xor(original_data, demodulated_data));
  ber = errors / length(original_data);
end

% Parâmetros iniciais
data_length = 10000000; % kkkkkk, ajustar aqui dependendo de onde for executar
data = randi([0, 1], data_length, 1);
snrs = 0:2:30;

% Adicionando uma constante pequena para evitar log(0)
epsilon = 1e-10;

% Gráfico 1: Desempenho de M-PSK
psk_orders = [4, 8, 16, 32];
psk_ber = zeros(length(psk_orders), length(snrs));

for i = 1:length(psk_orders)
  M = psk_orders(i);
  modulated_data = pskmod(data, M);

  for j = 1:length(snrs)
    snr = snrs(j);
    noisy_data = awgn(modulated_data, snr, 'measured');
    demodulated_data = pskdemod(noisy_data, M);
    psk_ber(i, j) = compute_ber(data, demodulated_data);
  end
end

figure; clf; % Limpar figura
hold on;
for i = 1:length(psk_orders)
  semilogy(snrs, max(psk_ber(i, :), epsilon), 'DisplayName', sprintf('PSK %d', psk_orders(i)));
end
xlabel('SNR [dB]');
ylabel('Bit Error Rate (BER)');
title('Performance of M-PSK');
legend('show');
grid on;
hold off;

% Gráfico 2: Desempenho de M-QAM
qam_orders = [4, 16, 64];
qam_ber = zeros(length(qam_orders), length(snrs));

for i = 1:length(qam_orders)
  M = qam_orders(i);
  modulated_data = qammod(data, M);

  for j = 1:length(snrs)
    snr = snrs(j);
    noisy_data = awgn(modulated_data, snr, 'measured');
    demodulated_data = qamdemod(noisy_data, M);
    qam_ber(i, j) = compute_ber(data, demodulated_data);
  end
end

figure; clf; % Limpar figura
hold on;
for i = 1:length(qam_orders)
  semilogy(snrs, max(qam_ber(i, :), epsilon), 'DisplayName', sprintf('QAM %d', qam_orders(i)));
end
xlim([0, 30]);
xlabel('SNR [dB]');
ylabel('Bit Error Rate (BER)');
title('Performance of M-QAM');
legend('show');
grid on;
hold off;

% Gráfico 3: Comparação PSK vs QAM
psk_orders_combined = [4, 16, 64];
qam_orders_combined = [4, 16, 64];
snrs = 0:2:40;
combined_ber = zeros(length(psk_orders_combined) + length(qam_orders_combined), length(snrs));

% PSK
for i = 1:length(psk_orders_combined)
  M = psk_orders_combined(i);
  modulated_data = pskmod(data, M);

  for j = 1:length(snrs)
    snr = snrs(j);
    noisy_data = awgn(modulated_data, snr, 'measured');
    demodulated_data = pskdemod(noisy_data, M);
    combined_ber(i, j) = compute_ber(data, demodulated_data);
  end
end

% QAM
for i = 1:length(qam_orders_combined)
  M = qam_orders_combined(i);
  modulated_data = qammod(data, M);

  for j = 1:length(snrs)
    snr = snrs(j);
    noisy_data = awgn(modulated_data, snr, 'measured');
    demodulated_data = qamdemod(noisy_data, M);
    combined_ber(length(psk_orders_combined) + i, j) = compute_ber(data, demodulated_data);
  end
end

figure()
hold on;
for i = 1:length(psk_orders_combined)
  semilogy(snrs, max(combined_ber(i, :), epsilon), 'DisplayName', sprintf('%d-PSK', psk_orders_combined(i)));
end
for i = 1:length(qam_orders_combined)
  semilogy(snrs, max(combined_ber(length(psk_orders_combined) + i, :), epsilon), 'DisplayName', sprintf('%d-QAM', qam_orders_combined(i)));
end
xlim([0, 40]);
xlabel('SNR [dB]');
ylabel('Bit Error Rate (BER)');
title('M-PSK vs M-QAM');
legend('show');
grid on;
hold off;

