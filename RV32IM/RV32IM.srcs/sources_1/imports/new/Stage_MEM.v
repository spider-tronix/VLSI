`timescale 1ns / 1ps

`include "defines.v"
`include "RamMemory.v"

module Stage_MEM#(parameter XLEN =32,
                   parameter WORDLENGTH = 8)
                (
                    input clk,
                    input [XLEN-1:0] Addr0,
                    input [XLEN-1:0] Addr1,
                    input [XLEN-1:0] Addr2,
                    input [XLEN-1:0] Addr3,
                    input [3:0] cs,re,we,
                    input [XLEN-1:0] data_i,
                    output [XLEN-1:0] data_o 
                );

RamMemory dm (.clk(clk), 
                .Addr0(Addr0), .Addr1(Addr1), .Addr2(Addr2), .Addr3(Addr3),
                .cs(cs), .re(re), .we(we),
                .data_i(data_i),
                .data_o(data_o) 
            );
endmodule