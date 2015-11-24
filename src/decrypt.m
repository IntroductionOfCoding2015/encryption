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
%
% bitset<64> decrypt(bitset<64>& cipher)
% {
% 	bitset<64> plain;
% 	bitset<64> currentBits;
% 	bitset<32> left;
% 	bitset<32> right;
% 	bitset<32> newLeft;
% 	// 第一步：初始置换IP
% 	for(int i=0; i<64; ++i)
% 		currentBits[63-i] = cipher[64-IP[i]];
% 	// 第二步：获取 Li 和 Ri
% 	for(int i=32; i<64; ++i)
% 		left[i-32] = currentBits[i];
% 	for(int i=0; i<32; ++i)
% 		right[i] = currentBits[i];
% 	// 第三步：共16轮迭代（子密钥逆序应用）
% 	for(int round=0; round<16; ++round)
% 	{
% 		newLeft = right;
% 		right = left ^ f(right,subKey[15-round]);
% 		left = newLeft;
% 	}
% 	// 第四步：合并L16和R16，注意合并为 R16L16
% 	for(int i=0; i<32; ++i)
% 		plain[i] = left[i];
% 	for(int i=32; i<64; ++i)
% 		plain[i] = right[i-32];
% 	// 第五步：结尾置换IP-1
% 	currentBits = plain;
% 	for(int i=0; i<64; ++i)
% 		plain[63-i] = currentBits[64-IP_1[i]];
% 	// 返回明文
% 	return plain;
% }
