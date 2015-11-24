addpath '../convolutional-coding/src'
load data

EFFICIENCY = 2;
SNR = -15:1:15;
ITERS = 100;

key = create_key();

without_error_rate = zeros(size(SNR));
with_error_rate = zeros(size(SNR));

for k = 1:length(SNR)
    snr = SNR(k);
    disp([num2str(k) '/' num2str(length(SNR)) ': SNR = ' num2str(snr)]);

    for iter = 1:ITERS
        % Without encryption.
        signals = sym_encode(data, EFFICIENCY);
        signals = transmit(signals, snr);
        recovered = sym_decode(signals, EFFICIENCY);

        without_error_rate(k) = ...
            without_error_rate(k) + ...
            sum(xor(data, recovered)) / length(data) / ITERS;

        % With encryption.
        encrypted = encrypt(data, key);
        signals = sym_encode(encrypted, EFFICIENCY);
        signals = transmit(signals, snr);
        encrypted = sym_decode(signals, EFFICIENCY);
        recovered = decrypt(encrypted, key);

        with_error_rate(k) = ...
            with_error_rate(k) + ...
            sum(xor(data, recovered)) / length(data) / ITERS;
    end
end

semilogy(SNR, with_error_rate, SNR, without_error_rate);
title 'Error Bit Rate'
legend('With Encryption', 'Without Encryption');
xlabel 'SNR/dB'
ylabel 'Eb'
