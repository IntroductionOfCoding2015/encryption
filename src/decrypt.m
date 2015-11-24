function data = decrypt(encrypted, key)
    IP_inv = [40 8 48 16 56 24 64 32 ...
			  39 7 47 15 55 23 63 31 ...
			  38 6 46 14 54 22 62 30 ...
			  37 5 45 13 53 21 61 29 ...
			  36 4 44 12 52 20 60 28 ...
			  35 3 43 11 51 19 59 27 ...
			  34 2 42 10 50 18 58 26 ...
			  33 1 41  9 49 17 57 25];

    len = length(encrypted);
    subkeys = keygen(key);  % Generate sub-keys.

    for start_pos = 1:64:len
        range = start_pos:start_pos+63;
        block = encrypted(range);

        left = block(33:64);
        right = block(1:32);

        for k = 1:16
            next_left = right;
            right = xor(left, Feistel(right, subkeys{17 - k}));
            left = next_left;
        end

        block = [left; right];
        block = fliplr(block(65 - IP_inv));  % Expansion.

        encrypted(range) = block;
    end

    data = encrypted;
end
