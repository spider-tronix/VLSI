`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/24/2020 04:01:59 PM
// Design Name:
// Module Name: reg_ID_EX
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
// Inputs from Control unit and STAGE_ID output to STAGE_EX
module reg_ID_EX#(parameter XLEN = 32)
                 (input rst,
                  clk,
                  input wire [5:0] stall,
                  input wire [2:0] ID_funct3,
                  input wire [6:0] ID_funct7,
                  input wire [XLEN - 1:0] ID_src1,
                  ID_src2,
                  input wire [4:0] ID_dest,
                  input wire [31:0] ID_imm,
                  input wire[1:0] ID_alu_op,
                  input wire ID_mem_read,
                  ID_mem_write,
                  ID_alu_src,
                  ID_mem_to_reg,
                  ID_reg_write,
                  ID_branch,
                  ID_jump,
                  ID_load,
                  input wire [XLEN-1:0] ID_link_addr,
                  ID_branch_addr,
                  input wire [XLEN-1:0] ID_data_src2_R,
                  output reg [2:0] EX_funct3,
                  output reg [6:0] EX_funct7,
                  output reg [XLEN - 1:0] EX_src1,
                  EX_src2,
                  output reg [4:0] EX_dest,
                  output reg [XLEN-1:0] EX_data_src2_R,
                  output reg [XLEN-1:0] EX_imm,
                  output reg [XLEN-1:0] EX_link_addr,
                  EX_branch_addr,
                  output reg[1:0] EX_alu_op,
                  output reg EX_mem_read,
                  EX_mem_write,
                  EX_alu_src,
                  EX_mem_to_reg,
                  EX_reg_write,
                  EX_branch,
                  EX_jump,
                  EX_load);
    always @ (posedge clk) begin
        if (rst || (stall[2] && !stall[3])) begin
            EX_alu_src     <= 1'b0;
            EX_mem_to_reg  <= 1'b0;
            EX_reg_write   <= 1'b0;
            EX_mem_read    <= 1'b0;
            EX_mem_write   <= 1'b0;
            EX_branch      <= 1'b0;
            EX_alu_op      <= 2'b00;
            EX_jump        <= 1'b0;
            EX_link_addr   <= 'b0;
            EX_branch_addr <= 'b0;
            EX_load        <= 'b0;
            // From STAGE_ID
            EX_funct3      <= 0;
            EX_funct7      <= 0;
            EX_src1        <= 0;
            EX_src2        <= 0;
            EX_data_src2_R <= 0;
            EX_dest        <= 0;
            EX_imm         <= 0;
            end else if (!stall[2]) begin
            EX_alu_src     <= ID_alu_src;
            EX_mem_to_reg  <= ID_mem_to_reg;
            EX_reg_write   <= ID_reg_write;
            EX_mem_read    <= ID_mem_read;
            EX_mem_write   <= ID_mem_write;
            EX_branch      <= ID_branch;
            EX_alu_op      <= ID_alu_op;
            EX_jump        <= ID_jump;
            EX_link_addr   <= ID_link_addr;
            EX_branch_addr <= ID_branch_addr;
            EX_load        <= ID_load;
            // From STAGE_ID
            EX_funct3      <= ID_funct3;
            EX_funct7      <= ID_funct7;
            EX_src1        <= ID_src1;
            EX_src2        <= ID_src2;
            EX_dest        <= ID_dest;
            EX_imm         <= ID_imm;
            EX_data_src2_R <= ID_data_src2_R;
        end
    end
endmodule
