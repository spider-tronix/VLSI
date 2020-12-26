`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2020 03:12:56 PM
// Design Name: 
// Module Name: RamMemory
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

module RamMemory #(parameter XLEN =32,
                   parameter WORDLENGTH = 8)
                  
                  (
                //    input clk,
                   input [XLEN-3:0] Addr,
                   input [3:0] cs,re,we,
                   input [XLEN-1:0] data_i,
                   output [XLEN-1:0] data_o
                   );

RAM_Module m0(.Addr(Addr),.data_i(data_i[WORDLENGTH-1:0]),
// .clk(clk),
                .re(re[0]),.we(we[0]),.cs(cs[0]),.data_o(data_o[WORDLENGTH-1:0]));
RAM_Module m1(.Addr(Addr),.data_i(data_i[2*WORDLENGTH-1:WORDLENGTH]),
// .clk(clk),
                .re(re[1]),.we(we[1]),.cs(cs[1]),.data_o(data_o[2*WORDLENGTH-1:WORDLENGTH]));
RAM_Module m2(.Addr(Addr),.data_i(data_i[3*WORDLENGTH-1:2*WORDLENGTH]),
// .clk(clk),
                .re(re[2]),.we(we[2]),.cs(cs[2]),.data_o(data_o[3*WORDLENGTH-1:2*WORDLENGTH]));
RAM_Module m3(.Addr(Addr),.data_i(data_i[4*WORDLENGTH-1:3*WORDLENGTH]),
// .clk(clk),
                .re(re[3]),.we(we[3]),.cs(cs[3]),.data_o(data_o[4*WORDLENGTH-1:3*WORDLENGTH]));
  
endmodule
