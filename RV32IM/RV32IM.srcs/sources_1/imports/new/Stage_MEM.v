`timescale 1ns / 1ps

`include "defines.v"
`include "RamMemory.v"

module Stage_MEM#(parameter XLEN =32,
                   parameter WORDLENGTH = 8)
                (
                    input wire clk, write_enable, select,
                    input [XLEN-1:0] Addr,
                    input [XLEN-1:0] data_i,
                    output [XLEN-1:0] data_o, 
                    input [2:0] funct3
                );
wire Addr_M [XLEN-3:0];
wire cs[3:0];
MMU MemControl (.Addr_i(Addr),.funct3(funct3),.cs(cs),.MMUEnable(1'b1),.Addr_o(Addr_M));
/*
RamMemory dm (.clk(clk), 
                    .Addr(), 
                    .cs(cs & write_enable), .re(re), .we(we),
                    .data_i(data_i),
                    .data_o(data_o) 
                );
    */
endmodule