function encrypted = encrypt(data, key)
    IP = [58 50 42 34 26 18 10 2 ...
          60 52 44 36 28 20 12 4 ...
          62 54 46 38 30 22 14 6 ...
          64 56 48 40 32 24 16 8 ...
          57 49 41 33 25 17 9  1 ...
          59 51 43 35 27 19 11 3 ...
          61 53 45 37 29 21 13 5 ...
          63 55 47 39 31 23 15 7];
    FP = [40 8 48 16 56 24 64 32 ...
          39 7 47 15 55 23 63 31 ...
          38 6 46 14 54 22 62 30 ...
          37 5 45 13 53 21 61 29 ...
          36 4 44 12 52 20 60 28 ...
          35 3 43 11 51 19 59 27 ...
          34 2 42 10 50 18 58 26 ...
          33 1 41  9 49 17 57 25];

    % Pad data if needed.
    len = length(data);
    padding = ceil(len / 64) * 64 - len;
    data = [data; zeros(padding, 1)];

    subkeys = keygen(key);  % Generate sub-keys.

    for start_pos = 1:64:len
        range = start_pos:start_pos+63;
        block = data(range);

        block = fliplr(block(65 - IP));  % IP.

        left = block(33:64);
        right = block(1:32);

        for k = 1:16
            next_left = right;
            right = xor(left, Feistel(right, subkeys{k}));
            left = next_left;
        end

        block = [left; right];
        block = fliplr(block(65 - FP));  % FP.

        data(range) = block;
    end

    encrypted = data;
end
