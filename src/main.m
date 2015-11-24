addpath '../convolutional-coding/src'
load data

EFFICIENCY = 2;
SNR = 0:10;
ITERS = 5;

data = randi([0 1], 1024, 1);
key = create_key();

without_correct_rate = zeros(size(SNR));
with_correct_rate = zeros(size(SNR));

for k = 1:length(SNR)
    snr = SNR(k);
    disp([num2str(k) '/' num2str(length(SNR)) ': SNR = ' num2str(snr)]);

    without_count = 0;
    with_count = 0;

    for iter = 1:ITERS
        % Without encryption.
        signals = sym_encode(data, EFFICIENCY);
        signals = transmit(signals, snr);
        recovered = sym_decode(signals, EFFICIENCY);

        if data == recovered
            without_count = without_count + 1;
        end

        % With encryption.
        encrypted = encrypt(data, key);
        signals = sym_encode(encrypted, EFFICIENCY);
        signals = transmit(signals, snr);
        encrypted = sym_decode(signals, EFFICIENCY);
        recovered = decrypt(encrypted, key);

        if data == recovered
            with_count = with_count + 1;
        end
    end

    without_correct_rate(k) = without_count / ITERS;
    with_correct_rate(k) = with_count / ITERS;
end
