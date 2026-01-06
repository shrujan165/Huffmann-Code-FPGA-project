# Huffman Coding IC
Implemented Huffman coding on a Basys3 board to compress 8-bit grayscale data, which was stored in a memory file generated via Vivado’s IP Catalog.

## Directory Tree

```text
Huffman_Coding_IC/
├─ huffman.sv ....... Main function for Huffman coding
├─ testbench.sv ..... RTL testbench
├─ pattern.sv ....... RTL testing pattern
├─ main.cpp ......... C++ function to compute Huffman coding (for generating testing pattern)
├─ input.txt ........ input image
└─ output.txt ....... output Huffman coding

