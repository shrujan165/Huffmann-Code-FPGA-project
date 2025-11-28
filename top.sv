// top.sv - Top module with Block Memory, VIO for reset, and ILA
module top(
  input clk,
  input rst_n
);

// VIO reset signal
logic rst_n;

// Block Memory signals
logic mem_ena;
logic [6:0] mem_addr;   // 7-bit address counter
logic [7:0] mem_douta;  // Output from block memory (1 cycle delayed)

// Control signals
logic in_valid;
logic in_valid_d;
logic [1:0] delay_cnt;  // 2-bit counter for delay (0-3 possible)

// Internal signals from huffman outputs
logic CNT_valid;
logic [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
logic code_valid;
logic [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
logic [7:0] M1, M2, M3, M4, M5, M6;
/*
// Instantiate VIO for reset control
vio_0 u_vio (
  .clk(clk),
  .probe_out0(rst_n)  // VIO controlled reset
);
*/
// Address counter and control logic
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mem_addr <= 7'd0;
    in_valid <= 1'b0;
    delay_cnt <= 2'd0;
  end else begin
    if (mem_addr < 7'd99) begin  // 30 rows (0-29)
      mem_addr <= mem_addr + 1'b1;
      in_valid <= 1'b1;
      delay_cnt <= 2'd0;
    end else if (delay_cnt < 2'd1) begin  // Stay at addr 29 for 3 more cycles
      mem_addr <= mem_addr;
      in_valid <= 1'b1;  // Keep valid high
      delay_cnt <= delay_cnt + 1'b1;
    end else begin  // After 3 cycle delay
      mem_addr <= mem_addr;
      in_valid <= 1'b0;
      delay_cnt <= delay_cnt;
    end
  end
end

// Instantiate Block Memory
assign mem_ena = 1'b1;  // Always enabled

blk_mem_gen_0 u_blk_mem (
  .clka(clk),
  .ena(mem_ena),
  .addra(mem_addr),
  .douta(mem_douta)  // 1 clock cycle delayed output
);

// Delay in_valid by 1 cycle to match memory latency
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    in_valid_d <= 1'b0;
  else
    in_valid_d <= in_valid;
end

// Instantiate huffman module
huffman u_huffman (
  .clk(clk),
  .rst_n(rst_n),
  .in_valid(in_valid_d),  // Delayed to match memory output
  .gray_data(mem_douta),  // Connected to block memory output
  .CNT_valid(CNT_valid),
  .CNT1(CNT1),
  .CNT2(CNT2),
  .CNT3(CNT3),
  .CNT4(CNT4),
  .CNT5(CNT5),
  .CNT6(CNT6),
  .code_valid(code_valid),
  .HC1(HC1),
  .HC2(HC2),
  .HC3(HC3),
  .HC4(HC4),
  .HC5(HC5),
  .HC6(HC6),
  .M1(M1),
  .M2(M2),
  .M3(M3),
  .M4(M4),
  .M5(M5),
  .M6(M6)
);

// Instantiate ILA for debugging
ila_0 u_ila (
  .clk(clk),
  .probe0(CNT_valid),    // [0:0]
  .probe1(CNT1),         // [7:0]
  .probe2(CNT2),         // [7:0]
  .probe3(CNT3),         // [7:0]
  .probe4(CNT4),         // [7:0]
  .probe5(CNT5),         // [7:0]
  .probe6(CNT6),         // [7:0]
  .probe7(code_valid),   // [0:0]
  .probe8(HC1),          // [7:0]
  .probe9(HC2),          // [7:0]
  .probe10(HC3),         // [7:0]
  .probe11(HC4),         // [7:0]
  .probe12(HC5),         // [7:0]
  .probe13(HC6),         // [7:0]
  .probe14(M1),          // [7:0]
  .probe15(M2),          // [7:0]
  .probe16(M3),          // [7:0]
  .probe17(M4),          // [7:0]
  .probe18(M5),          // [7:0]
  .probe19(M6),           // [7:0]
  .probe20(rst_n)
);

endmodule