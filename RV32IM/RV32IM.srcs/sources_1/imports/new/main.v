`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: Execution_main_source
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Execution_main_source#(parameter enable = 1'b1,parameter XLEN = 32)
    (input clk,
    input rst,
    output wire [5:0]stall,
    output wire [XLEN-1:0]ROM_data,
    output wire [XLEN-1:0] RAM_data_read,
    output wire [XLEN-1:0] RAM_data_write);
// To ROM
    wire [XLEN-1:0]ROM_addr;
    wire ROM_enable, ROM_rst;
// From ROM
    wire ROM_busy;
    // wire [XLEN-1:0]ROM_data;
// To RAM
    // wire [XLEN-1:0] RAM_data_read;
// From RAM
    wire [XLEN-3:0] RAM_Addr;
    // wire [XLEN-1:0] RAM_data_write;
    wire [3:0] RAM_cs, RAM_re, RAM_wr;
// Debug
    // wire [5:0]stall;

RV32Core core1(
    // Inputs
    .clk(clk),
    .rst(rst),
    // Output
    .stall(stall),
    // To ROM
    .ROM_addr(ROM_addr), .ROM_enable(ROM_enable), .ROM_rst(ROM_rst),
    // From ROM
    .ROM_busy(ROM_busy), .ROM_data(ROM_data),
    // To RAM
    .RAM_data_read(RAM_data_read), 
    // From RAM
    .RAM_Addr(RAM_Addr), .RAM_data_write(RAM_data_write),
    .RAM_cs(RAM_cs), .RAM_re(RAM_re), .RAM_wr(RAM_wr)
);
// Mem instantiations
RamMemory Dm ( .clk(clk),
                    .cs(RAM_cs),.re(RAM_re),.we(RAM_wr),.Addr(RAM_Addr),.data_i(RAM_data_write),.data_o(RAM_data_read));

ROM_Module fetch_instr(
    .clk(clk),
    .Addr(ROM_addr), .Instr(ROM_data), .mem_busy(ROM_busy),
    .ROM_Enable(ROM_enable),.ROM_Rst(ROM_rst)
);
endmodule

