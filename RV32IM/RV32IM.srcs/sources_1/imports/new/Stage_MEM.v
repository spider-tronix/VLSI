`timescale 1ns / 1ps

`include "defines.v"
`include "RamMemory.v"

module Stage_MEM#(parameter XLEN = 32,
                  parameter WORDLENGTH = 8)
                 (
                //   input wire clk,
                  input wire select,
                  input [XLEN-1:0] Addr,
                  input [XLEN-1:0] data_i,
                  input [2:0] funct3,
                  input mem_read,
                  mem_write,
                  output reg [XLEN-1:0] data_o);
    wire [XLEN-3:0] Addr_M ;
    wire [3:0] cs,re,wr;
    wire [XLEN-1:0] data_to_mem,data_from_mem;
    
    MMU MemControl (.funct3(funct3),.mem_read(mem_read),.mem_write(mem_write),.MMUEnable(select),.cs(cs),.re(re),.wr(wr),.Addr_o(Addr_M),.Addr_i(Addr));
    input_shifter DataIN (.data_in(data_i),.funct3(funct3),.Addr(Addr[1:0]),.data_out(data_to_mem));
    output_shifter DataOut (.data_in(data_from_mem),.funct3(funct3),.Addr(Addr[1:0]),.data_out(data_o));
    RamMemory Dm ( //.clk(clk),
                    .cs(cs),.re(re),.we(wr),.Addr(Addr_M),.data_i(data_to_mem),.data_o(data_from_mem));
    always @(*)
    begin
        if (mem_read == 0)
            data_o = Addr;
            end
        
        endmodule
