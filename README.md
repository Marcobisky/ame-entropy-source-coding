# Adaptive Markov Entropy Coding Project

This project explores entropy-based compression techniques using **Huffman Coding**, **Fano Coding**, and an innovative **Second-order Adaptive Markov Encoding (AME)** scheme. Implementations and evaluations are performed using MATLAB and Python.

## Overview

Data compression is essential for efficient storage and transmission. The project focuses on comparing Huffman and Fano coding, widely used lossless entropy-based methods, and introduces AME coding, which enhances compression by leveraging predictive modeling.

---

## Features

- **Huffman Coding**:
  - Assigns shorter codes to frequently occurring symbols.
  - MATLAB implementation with tree visualization.
- **Fano Coding**:
  - Similar to Huffman but uses frequency balancing.
  - MATLAB implementation with tree visualization.
- **Second-order Adaptive Markov Encoding (AME)**:
  - Pre-processes text to predict and compress based on structural patterns.
  - Python implementation with adaptive tree modeling.

---

## Implementation

### Without AME:
1. Analyze character frequencies in `original.txt`.
2. Perform Huffman and Fano coding.
3. Compute performance metrics:
   - Average Code Length (L̄)
   - Code Rate (R)
   - Efficiency (η)
   - Compression Ratio (ξ).

### With AME:
1. Pre-process `original.txt` using AME.
2. Apply Huffman and Fano coding to the AME-processed text.
3. Evaluate binary file size improvements.

---

## Results

### Performance Metrics:
| Metric        | Huffman | Fano   |
|---------------|---------|--------|
| Avg. Code Len (L̄) | 4.5023  | 8.4244 |
| Code Rate (R) | 0.9909  | 0.5282 |
| Efficiency (η) | 0.9909  | 0.5282 |
| Compression Ratio (ξ) | 0.5628  | 1.0530 |

### Impact of AME:
- AME improves binary file size:
  - **Huffman**: 5.25% reduction.
  - **Fano**: 4.37% reduction.
- Efficiency increases with longer texts.

---

## Visualization

### Huffman Tree:
- Visualized for `original.txt`.

### Fano Tree:
- Visualized for `processed.txt`.

---

## Files and Resources

### Input Files:
- `original.txt`: Source text (first 3 chapters of *Game of Thrones*).

### Output Files:
- `binary_huffman.txt`, `binary_fano.txt`: Encoded binary files.
- `processed.txt`: AME-encoded file.
- `received_huffman.txt`, `received_fano.txt`: Decoded files.

### Source Code:
- Python:
  - `adaptive_markov_encode.py`: AME encoding.
  - `adaptive_markov_decode.py`: AME decoding.
- MATLAB:
  - `huffman_encode.m`, `fano_encode.m`: Encoding procedures.
  - `huffman_decode.m`, `fano_decode.m`: Decoding procedures.

### Visuals:
- Huffman and Fano trees, character frequency distributions.

---

## Contact us

Please contact us if you need help: 
* Jinming Ren (marcobisky@outlook.com)
* Yuhao Liu