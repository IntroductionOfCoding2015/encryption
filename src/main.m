addpath '../convolutional-coding/src'
load data
close all

EFFICIENCY = 2;
SNR = -15:1:15;
ITERS = 10;

key = create_key();

without_error_rate = zeros(size(SNR));
with_error_rate = zeros(size(SNR));

for k = 1:length(SNR)
    snr = SNR(k);
    disp([num2str(k) '/' num2str(length(SNR)) ': SNR = ' num2str(snr)]);

    for iter = 1:ITERS
        % Without encryption.
        signals = conv_send(data, true, EFFICIENCY, []);
        signals = transmit(signals, snr);
        recovered = conv_receive(signals, true, EFFICIENCY, [], true);

        err = xor(data, recovered);
        without_error_rate(k) = without_error_rate(k) + ...
                                sum(err) / length(data) / ITERS;

        % figure
        % for block = 1:16
        %     range = ((block - 1) * 64 + 1):(block * 64);
        %     subplot(4, 4, block);
        %     stem(err(range))
        %     axis([1 64 0 1])
        % end
        % suptitle(['Error Map, SNR = ' num2str(snr) 'dB, Without Encryption']);

        % With encryption.
        encrypted = encrypt(data, key);
        signals = conv_send(encrypted, true, EFFICIENCY, []);
        signals = transmit(signals, snr);
        encrypted = conv_receive(signals, true, EFFICIENCY, [], true);
        recovered = decrypt(encrypted, key);

        err = xor(data, recovered);
        with_error_rate(k) = with_error_rate(k) + ...
                             sum(err) / length(data) / ITERS;
        % figure
        % for block = 1:16
        %     range = ((block - 1) * 64 + 1):(block * 64);
        %     subplot(4, 4, block);
        %     stem(err(range))
        %     axis([1 64 0 1])
        % end
        % suptitle(['Error Map, SNR = ' num2str(snr) 'dB, With Encryption']);
    end
end

figure
semilogy(SNR, with_error_rate, SNR, without_error_rate);
title 'Error Bit Rate'
legend('With Encryption', 'Without Encryption');
xlabel 'SNR/dB'
ylabel 'Eb'
