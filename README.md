# Source Coding for Game of Thrones

This project explores the implementation of **Huffman Coding** and **Fano Coding** for compressing the first three chapters of *Game of Thrones*. It also introduces a novel **Second-order Adaptive Markov Encoding (AME)** technique to enhance compression efficiency by leveraging the structural patterns in the source text.

Further details see `report.pdf`.

## Features

- **Huffman Coding**: A lossless compression algorithm that generates optimal prefix-free codes by assigning shorter codes to frequently occurring characters.
- **Fano Coding**: A similar algorithm to Huffman, but less efficient for uniformly distributed symbol probabilities.
- **Second-order AME**: A pre-processing method to uncover source structures, improving entropy coding performance.

## Key Metrics

The project evaluates the following metrics to compare the performance of the algorithms:

- **Average Code Length (L̄)**
- **Code Rate (R)**
- **Efficiency (η)**
- **Compression Ratio (ξ)**

## Implementation Details

1. **Without AME**:
   - Calculated the frequency of each character in the source text.
   - Generated Huffman and Fano trees for encoding.
   - Measured compression metrics.

2. **With AME**:
   - Applied AME pre-processing to extract memoryless components.
   - Encoded and decoded the AME-processed text.
   - Compared the compressed file sizes with and without AME.

## Results

- **Huffman Coding** consistently outperformed **Fano Coding** in all metrics.
- The **AME** technique demonstrated significant savings in compressed file sizes.

| Metric         | Huffman | Fano  |
|----------------|---------|-------|
| Avg Code Length| 4.4769  | 8.6370|
| Code Rate (R)  | 0.9897  | 0.5117|
| Efficiency (η) | 0.9897  | 0.5117|
| Compression (ξ)| 0.5596  | 1.0796|

## Code and Tools

- MATLAB scripts for Huffman and Fano encoding/decoding.
- Python implementation of the AME algorithm.

## Future Work

- Enhance AME by using higher-order Markov models.
- Explore advanced mathematical models for better structure detection and compression.

## Authors

- Jinming Ren
- Yuhao Liu

## Contact

For further details, refer to the documentation or contact us at marcobisky@outlook.com.

---
This project demonstrates the efficacy of source coding techniques in achieving efficient data compression and highlights the potential of combining structural analysis with entropy coding.