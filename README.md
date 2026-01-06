# Huffman Coding IC
Implemented Huffman coding on a Basys3 board to compress 8-bit grayscale data, which was stored in a memory file generated via Vivado’s IP Catalog.

# Requirements

### HDL: SystemVerilog

## Directory Tree

```text
Huffman_Coding_IC/
├─ huffman.sv ....... Main function for Huffman coding
├─ tb.sv ..... RTL testbench
├─ top.sv ....... Top module with Block Memory, VIO for reset, and ILA

├─ 100.coe ........ Memory file generated from vivado ip catalog




