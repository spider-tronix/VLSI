`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2020 11:09:10
// Design Name: 
// Module Name: controUnit_TestBench
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
`ifndef DEFINES_V
    `define OP_LUI      7'b0110111
    `define OP_AUIPC    7'b0010111
    `define OP_JAL      7'b1101111
    `define OP_JALR     7'b1100111
    `define OP_BRANCH   7'b1100011
    `define OP_LOAD     7'b0000011  // I-Type
    `define OP_STORE    7'b0100011  // S-Type
    `define OP_OP_IMM   7'b0010011  // I-Type
    `define OP_OP       7'b0110011  // R-Type
    `define OP_MISC_MEM 7'b0001111

`endif
    `define OPCODE_WIDTH 7
    `define OPCODE_NO 4

module controUnit_TestBench;
    // Input
    reg[`OPCODE_WIDTH - 1:0] opcode;
    // Output
    wire[1:0] alu_op;
    wire mem_read,mem_write,alu_src,mem_to_reg,reg_write;

    // UUT
    ControlUnit CU(
        .opcode(opcode),
        .alu_op(alu_op),
        .mem_read(mem_read),.mem_write(mem_write), .alu_src(alu_src), .mem_to_reg(mem_to_reg), .reg_write(reg_write)  
    );
    
    reg [`OPCODE_NO - 1:0]opcode_list[`OPCODE_WIDTH - 1:0];
    initial begin
    opcode_list[0] = `OP_OP;
    opcode_list[1] = `OP_OP_IMM;
    opcode_list[2] = `OP_LOAD;
    opcode_list[3] = `OP_STORE;
    end
    // Testing
    integer i;
    initial begin
        # 5
        $monitor(opcode, alu_op, mem_read, mem_write, alu_src, mem_to_reg, reg_write);
        
        opcode = `OP_OP;
        # 200;
        opcode = `OP_OP_IMM;
        #200;
        opcode = `OP_LOAD;
        # 200;
        opcode = `OP_STORE;
        #200;
        
    end
endmodule

