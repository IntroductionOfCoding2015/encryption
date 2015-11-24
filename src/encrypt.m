function encrypted = encrypt(data, key)
    IP = [58 50 42 34 26 18 10 2 ...
          60 52 44 36 28 20 12 4 ...
          62 54 46 38 30 22 14 6 ...
          64 56 48 40 32 24 16 8 ...
          57 49 41 33 25 17 9  1 ...
          59 51 43 35 27 19 11 3 ...
          61 53 45 37 29 21 13 5 ...
          63 55 47 39 31 23 15 7];

    % Pad data if needed.
    len = length(data);
    padding = ceil(len / 64) * 64 - len;
    data = [data; zeros(padding, 1)];

    subkeys = keygen(key);  % Generate sub-keys.

    for start_pos = 1:64:len
        range = start_pos:start_pos+63;
        block = data(range);

        block = fliplr(block(65 - IP));  % Expansion.

        left = block(33:64);
        right = block(1:32);

        for k = 1:16
            next_left = right;
            right = xor(left, Feistel(right, subkeys{k}));
            left = next_left;
        end

        data(range) = [left; right];
    end

    encrypted = data;
end

%
% bitset<64> encrypt(bitset<64>& plain)
% {
% 	bitset<64> cipher;
% 	bitset<64> currentBits;
% 	bitset<32> left;
% 	bitset<32> right;
% 	bitset<32> newLeft;
% 	// 第一步：初始置换IP
% 	for(int i=0; i<64; ++i)
% 		currentBits[63-i] = plain[64-IP[i]];
% 	// 第二步：获取 Li 和 Ri
% 	for(int i=32; i<64; ++i)
% 		left[i-32] = currentBits[i];
% 	for(int i=0; i<32; ++i)
% 		right[i] = currentBits[i];
% 	// 第三步：共16轮迭代
% 	for(int round=0; round<16; ++round)
% 	{
% 		newLeft = right;
% 		right = left ^ f(right,subKey[round]);
% 		left = newLeft;
% 	}
% 	// 第四步：合并L16和R16，注意合并为 R16L16
% 	for(int i=0; i<32; ++i)
% 		cipher[i] = left[i];
% 	for(int i=32; i<64; ++i)
% 		cipher[i] = right[i-32];
% 	// 第五步：结尾置换IP-1
% 	currentBits = cipher;
% 	for(int i=0; i<64; ++i)
% 		cipher[63-i] = currentBits[64-IP_1[i]];
% 	// 返回密文
% 	return cipher;
% }
