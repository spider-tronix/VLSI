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


module controUnit_TestBench;
    // Input
    reg[6:0] opcode;
    // Output
    wire[1:0] alu_op;
    wire mem_read,mem_write,alu_src,mem_to_reg,reg_write;

    // UUT
    ControlUnit CU(
        .opcode(opcode),
        .alu_op(alu_op),
        .mem_read(mem_read),.mem_write(mem_write), .alu_src(alu_src), .mem_to_reg(mem_to_reg), .reg_write(reg_write)  
    );
    

endmodule
