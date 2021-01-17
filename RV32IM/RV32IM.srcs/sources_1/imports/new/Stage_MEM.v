`timescale 1ns / 1ps

`include "defines.v"
// `include "RamMemory.v"

module Stage_MEM#(parameter XLEN = 32,
                  parameter WORDLENGTH = 8)
                 (
                //   input wire clk,
                  input wire select,
                  input [XLEN-1:0] Addr,
                  input [XLEN-1:0] data_i, data_from_mem,
                  output [XLEN-3:0]Addr_M,
                  output [XLEN-1:0] data_to_mem,
                  output [3:0] cs,re,wr,
                  input [2:0] funct3,
                  input mem_read,
                  mem_write,
                  output reg [XLEN-1:0] data_o,
                  output stallreq);
    // wire  [XLEN-3:0]Addr_M ;
    // wire [3:0] cs,re,wr;
    wire [XLEN-1:0] data_o_shift;
    reg [XLEN-1:0] data_o_temp;
    MMU MemControl (.funct3(funct3),.mem_read(mem_read),.mem_write(mem_write),.MMUEnable(select),.cs(cs),.re(re),.wr(wr),.Addr_i(Addr), .Addr_o(Addr_M));
    input_shifter DataIN (.data_in(data_i),.funct3(funct3),.Addr(Addr[1:0]),.data_out(data_to_mem));
    output_shifter DataOut (.data_in(data_from_mem),.funct3(funct3),.Addr(Addr),.data_out(data_o_shift));
    // RamMemory Dm ( .clk(clk),
    //                 .cs(cs),.re(re),.we(wr),.Addr(Addr_M),.data_i(data_to_mem),.data_o(data_from_mem));
    always @(*)
    begin
        if (mem_read == 0)
            data_o_temp <= Addr;
        data_o = (mem_read)?data_o_shift:data_o_temp;
    end
    assign stallreq = 0; // TODO check for mem stall conditions
endmodule
