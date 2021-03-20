`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2020 20:51:21
// Design Name: 
// Module Name: Stage_EX
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
`include "defines.v"
// `include "ALU_control_unit.v"
// `include "ALU_module.v"

module Stage_EX#(parameter XLEN= 32, 
                parameter ALU_SELECT_SIZE = 5)
    (
        input[1:0] ALUOp,
        input[6:0] funct7,
        input[2:0] funct3,
        input [XLEN-1:0] rs1, rs2, rs3, link_addr,
        input jump, 
        input instr_float,
        input [2:0] FPU_op,
        input [4:0] rs2_address,
        // input clk, 
        input ALU_Reset, select,
        output [XLEN-1:0]result,
        output zero_flag, stallreq);

    wire [4:0] FPU_control_line;

    wire [XLEN-1:0]result_temp, FPU_result;
    wire [4:0]ALU_control_line;
    ALU_control ALU_CU(.ALUOp(ALUOp),
                        .funct7(funct7),
                        .funct3(funct3),
                        .ALU_control_line(ALU_control_line),
                        .rst(ALU_Reset)
                       );
    ALU_Module ALU( .rs1(rs1),
                    .rs2(rs2),
                    .ALU_Reset(ALU_Reset),
                    .ALU_Enable(enable),
                    .ALUOp(ALU_control_line),
                    .result(result_temp),
                    .zero_flag(zero_flag)
    );

    FPU_control FPU_CU ( .FPUOp(FPU_op),
                         .funct7(funct7),
                         .funct3(funct3),
                         .rs2(rs2_address),
                         .rst(ALU_Reset),
                         // Output
                         .FPU_control_line(FPU_control_line)
    );  

    FPU_module FPU( .rs1(rs1),
                    .rs2(rs2),
                    .rs3(rs3),
                    .FPU_control_line(FPU_control_line),
                    .rst(ALU_Reset),
                    // Output
                    .result(FPU_result)
    );

assign result = (jump)?link_addr:
                (instr_float)?FPU_result:result_temp;
assign stallreq = 0;
endmodule
