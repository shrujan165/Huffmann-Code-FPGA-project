// top_tb.sv - Testbench for top module (100-depth Block RAM)
`timescale 1ns/1ps

module top_tb;

// Clock and reset
logic clk;
logic rst_n;

// Instantiate DUT
top u_top (
  .clk(clk),
  .rst_n(rst_n)
);

// Clock generation - 10ns period (100MHz)
initial begin
  clk = 0;
  forever #5 clk = ~clk;
end

// Test stimulus
initial begin
  // Initialize
  rst_n = 0;
  
  // Apply reset
  repeat(3) @(posedge clk);
  rst_n = 1;
  
  
  // Wait for address counter to finish (100 cycles + delay cycles + margin)
  // 100 address cycles + 2 delay cycles + 10 margin = 112 cycles
  repeat(200) @(posedge clk);
  
  // Display some internal signals for verification
  $display("============================================");
  $display("Simulation completed successfully!");
  $display("Check waveforms for:");
  $display("  - mem_addr counting 0->99");
  $display("  - in_valid high during reads");
  $display("  - in_valid_d delayed by 1 cycle");
  $display("  - mem_douta showing block memory data");
  $display("  - Huffman outputs responding");
  $display("============================================");
  
  $finish;
end

/*
// Optional: Monitor key signals
initial begin
  $monitor("Time=%0t | addr=%0d | in_valid=%b | data=%h", 
           $time, u_top.mem_addr, u_top.in_valid, u_top.mem_douta);
end

*/
// Waveform dump for viewing
initial begin
  $dumpfile("top_tb.vcd");
  $dumpvars(0, top_tb);
end

endmodule