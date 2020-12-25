`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03.10.2020 13:00:11
// Design Name:
// Module Name: ControlUnit
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

`timescale 1ns / 1ps

module ControlUnit(input clk,
                   input[6:0] opcode,
                   output reg[1:0] alu_op,
                   output reg mem_read,
                   mem_write,
                   alu_src,
                   mem_to_reg,
                   reg_write,
                   branch,
                   jump,
                   output reg [4:0] current_stage);
    
    reg [4:0]next_stage;
    
    initial
    begin
        current_stage <= `STAGE_IF;
    end
    
    always @(negedge clk)
    begin
        current_stage = next_stage;
        case(current_stage)
            `STAGE_IF:
            begin
                next_stage = `STAGE_ID;
            end
            `STAGE_ID:
            begin
                next_stage = `STAGE_EX;
            end
            `STAGE_EX:
            begin
                next_stage = `STAGE_MEM;
            end
            `STAGE_MEM:
            begin
                next_stage = `STAGE_WB;
            end
            `STAGE_WB:
            begin
                next_stage = `STAGE_IF;
            end
            default:
            begin
                next_stage = `STAGE_IF;
            end
        endcase
    end
    
    always @(negedge clk)
    begin
        case(opcode)
            `OP_OP:
            begin
                alu_src    = 1'b0;
                mem_to_reg = 1'b0;
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                jump       = 1'b0;
                alu_op     = 2'b10;
            end
            `OP_OP_IMM:
            begin
                alu_src    = 1'b1;
                mem_to_reg = 1'b0;
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                jump       = 1'b0;
                alu_op     = 2'b10;
            end
            `OP_LOAD:
            begin
                alu_src    = 1'b1;
                mem_to_reg = 1'b1;
                reg_write  = 1'b1;
                mem_read   = 1'b1;
                mem_write  = 1'b0;
                branch     = 1'b0;
                jump       = 1'b0;
                alu_op     = 2'b00;
            end
            `OP_STORE:
            begin
                alu_src    = 1'b1;
                mem_to_reg = 1'bX;
                reg_write  = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b1;
                branch     = 1'b0;
                jump       = 1'b0;
                alu_op     = 2'b00;
            end
            `OP_BRANCH:
            begin
                alu_src    = 1'b1;
                mem_to_reg = 1'bX;
                reg_write  = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b1;
                jump       = 1'b0;
                alu_op     = 2'b01;
            end
            //to be defined
            `OP_JALR:
            begin
                alu_src    = 1'b1;
                mem_to_reg = 1'bX;
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                jump       = 1'b1;
                alu_op     = 2'b11;
            end
            `OP_JAL:
            begin
                alu_src    = 1'b1;
                mem_to_reg = 1'bX;
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                alu_op     = 2'b11;
                jump       = 1'b1;
            end
            `OP_AUIPC:
            begin
                alu_src    = 1'b1;
                mem_to_reg = 1'bX;
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                jump       = 1'b0;
                alu_op     = 2'b11;
            end
            `OP_LUI:
            begin
                alu_src    = 1'b1;
                mem_to_reg = 1'bX;
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                alu_op     = 2'b11;
                jump       = 1'b0;
            end
            
            default:
            begin
                alu_src    = 1'b0;
                mem_to_reg = 1'b0;
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                alu_op     = 2'b00;
                jump       = 1'b0;
            end
            
        endcase
    end
    
endmodule
