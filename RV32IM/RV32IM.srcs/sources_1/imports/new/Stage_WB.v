`timescale 1ns / 1ps
`include "Registers_Module.v"

module Stage_WB#(parameter XLEN=32)
                (
                input wire select, clk, write_enable, 
                input MemtoReg, jump,
                input [XLEN-1:0] PC,
                input [XLEN-1:0]data_from_EX,
                input [XLEN-1:0]data_from_MEM,
                input [4:0] register_address
                );
wire [XLEN-1:0] dummy1, dummy2;
wire [XLEN-1:0] data;

assign data= (jump)? PC + 4:
             (MemtoReg== 1'b1)? data_from_MEM : data_from_EX;

    Registers_Module regs(
        .clk(clk),
        .src1(5'bzzzzz), .src2(5'bzzzzz), .dest(register_address),
        .we(write_enable & select), .re(0),.re1(0), .re2(0),
        .rs1(dummy1), .rs2(dummy2), .rd(data)
    );

endmodule