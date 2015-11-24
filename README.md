# 第二次编程练习 - 加解密

未说明时，数据均为列矢量。

## Part I

### 子密钥生成 `keygen`

- 输入
    - `key`: 64bits original key
- 输出
    - `subkeys`: 16 cells, each contains one 48bits subkey

## Part II

### 密码函数 `Feistel`

- 输入
    - `R`: Half Block（长度32，logical array）
    - `key`: 密钥（长度48，logical array)
- 输出
    - `feistel_out`: f(R, k)（长度32，logical array）

## Part III

### 加密 `encrypt`

- 输入
    - `data`: 输入数据流
    - `key`: 64 位密钥
- 输出
    - `encrypted`: 加密数据流

### 解密 `decrypt`

- 输入
    - `encrypted`: 加密数据流
    - `key`: 64 位密钥
- 输出
    - `data`: 解密后数据流

### 密钥生成 `create_key`

- 输入
    - `num`: 所需密钥数目，默认为 1
- 输出
    - `key`: `num` 个密钥，每列为一个 64 位密钥

### 主程序 `main`

- 计算误比特率
- 画出误码图案

## 实验结果

### 误比特率

![误比特率](report/error_bit_rate.png)

### 误码图案

![未加密时误码图案](report/error_map_5dB_without.png)

![加密时误码图案](report/error_map_5dB_with.png)
