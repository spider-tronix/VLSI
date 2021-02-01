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

module ControlUnit#(parameter XLEN = 32)
                   (input rst,
                    input[6:0] opcode,
                    input [XLEN-1:0] PC,
                    IR,
                    data_src1,
                    input stallreq_MEM,
                    stallreq_EX,
                    stallreq_ID,
                    stallreq_IF,
                    output reg[1:0] alu_op,
                    output reg[2:0] FPU_op,
                    output reg mem_read,
                    mem_write,
                    alu_src,
                    mem_to_reg,
                    reg_write,
                    reg_write_F,
                    branch,
                    jump,
                    load,
                    load_F,
                    output reg [5:0]stall,
                    output reg [4:0] current_stage,
                    output reg [XLEN - 1:0] branch_addr,
                    link_addr);
    
    always @ (*) begin
        if (rst) begin
            stall <= 6'b000000;
            end else if (stallreq_MEM) begin
            stall <= 6'b011111;
            end else if (stallreq_EX) begin
            stall <= 6'b001111;
            end else if (stallreq_ID) begin
            stall <= 6'b000111;
            end else if (stallreq_IF) begin
            stall <= 6'b000011;
            end else begin
            stall <= 6'b000000;
        end
    end
    wire[XLEN - 1:0] reg1_plus_I_imm;
    wire[XLEN - 1:0] pc_plus_J_imm;
    wire[XLEN - 1:0] pc_plus_B_imm;
    wire[XLEN - 1:0] pc_plus_4;
    wire[11:0] I_imm       = IR[31:20];
    wire[XLEN - 1:0] J_imm = $signed({{12{IR[31]}}, IR[19:12], IR[20], IR[30:21], 1'b0})/4;
    wire[XLEN - 1:0] B_imm = $signed({{20{IR[31]}}, IR[7], IR[30:25], IR[11:8], 1'b0})/4;
    
    assign reg1_plus_I_imm = data_src1 + {{20{I_imm[11]}}, I_imm};
    assign pc_plus_J_imm   = PC + J_imm;
    assign pc_plus_B_imm   = PC + B_imm;
    assign pc_plus_4       = PC + 1;
    
    // reg [4:0]next_stage;
    initial
    begin
        current_stage <= 5'b11111;
    end
    
    always @(*)
    begin
        case(opcode)
            `OP_OP:
            begin
                alu_src     <= 1'b0;
                mem_to_reg  <= 1'b0;
                reg_write   <= 1'b1;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b10;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                FPU_op      <= 3'bX;
            end
            `OP_OP_IMM:
            begin
                alu_src     <= 1'b1;
                mem_to_reg  <= 1'b0;
                reg_write   <= 1'b1;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b10;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                FPU_op      <= 3'bX;
                
            end
            `OP_LOAD:
            begin
                alu_src     <= 1'b1;
                mem_to_reg  <= 1'b1;
                reg_write   <= 1'b1;
                mem_read    <= 1'b1;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b00;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 1;
                FPU_op      <= 3'bX;
                
            end
            `OP_STORE:
            begin
                alu_src     <= 1'b1;
                mem_to_reg  <= 1'bX;
                reg_write   <= 1'b0;
                mem_read    <= 1'b0;
                mem_write   <= 1'b1;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b00;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                FPU_op      <= 3'bX;
                
            end
            `OP_BRANCH:
            begin
                alu_src     <= 1'b1;
                mem_to_reg  <= 1'bX;
                reg_write   <= 1'b0;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b1;
                jump        <= 1'b0;
                alu_op      <= 2'b01;
                branch_addr <= pc_plus_B_imm;
                $display("\nBranch Offset %d",B_imm);
                
                link_addr <= 'b0;
                load      <= 0;
                FPU_op      <= 3'bX;
                
            end
            `OP_JALR:
            begin
                alu_src     <= 1'b1;
                mem_to_reg  <= 1'b0;
                reg_write   <= 1'b1;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b1;
                alu_op      <= 2'b11;
                branch_addr <= reg1_plus_I_imm;
                link_addr   <= pc_plus_4;
                load        <= 0;
                FPU_op      <= 3'bX;
                
            end
            `OP_JAL:
            begin
                alu_src    <= 1'b1;
                mem_to_reg <= 1'b0;
                reg_write  <= 1'b1;
                mem_read   <= 1'b0;
                mem_write  <= 1'b0;
                branch     <= 1'b0;
                alu_op     <= 2'b11;
                jump       <= 1'b1;
                // $display("\nOffset %d",J_imm);
                
                branch_addr <= pc_plus_J_imm;
                link_addr   <= pc_plus_4;
                load        <= 0;
                FPU_op      <= 3'bX;
                
            end
            `OP_AUIPC:
            begin
                alu_src     <= 1'b1;
                mem_to_reg  <= 1'bX;
                reg_write   <= 1'b1;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b11;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                FPU_op      <= 3'bX;
                
            end
            `OP_LUI:
            begin
                alu_src     <= 1'b1;
                mem_to_reg  <= 1'bX;
                reg_write   <= 1'b1;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                alu_op      <= 2'b11;
                jump        <= 1'b0;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                FPU_op      <= 3'bX;
            end
            `OP_FLW:
            begin
                alu_src     <= 1'b1;
                mem_to_reg  <= 1'b1;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
                mem_read    <= 1'b1;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b00;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                load_F      <= 1;
                FPU_op      <= 3'b100;
            end
            `OP_FSW:
            begin
                alu_src     <= 1'b1;
                mem_to_reg  <= 1'bX;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b0;
                mem_read    <= 1'b0;
                mem_write   <= 1'b1;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b00;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                load_F      <= 0;
                FPU_op      <= 3'b100;
            end
            `OP_F_OP:
            begin
                alu_src     <= 1'b0;
                mem_to_reg  <= 1'b0;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b11;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                load_F      <= 0;
                FPU_op      <= 3'b111;
            end
            `OP_FNMADD_S:
            begin
                alu_src     <= 1'b0;
                mem_to_reg  <= 1'b0;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b10;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                load_F      <= 0;
                FPU_op      <= 3'b011;
            end
            `OP_FMADD_S:
            begin
                alu_src     <= 1'b0;
                mem_to_reg  <= 1'b0;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b10;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                load_F      <= 0;
                FPU_op      <= 3'b000;
            end
            `OP_FMSUB_S:
            begin
                alu_src     <= 1'b0;
                mem_to_reg  <= 1'b0;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b10;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                load_F      <= 0;
                FPU_op      <= 3'b001;
            end
            `OP_FNMSUB_S:
            begin
                alu_src     <= 1'b0;
                mem_to_reg  <= 1'b0;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b10;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                load_F      <= 0;
                FPU_op      <= 3'b010;
            end
            default:
            begin
                alu_src     <= 1'b0;
                mem_to_reg  <= 1'b0;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
                mem_read    <= 1'b0;
                mem_write   <= 1'b0;
                branch      <= 1'b0;
                jump        <= 1'b0;
                alu_op      <= 2'b10;
                branch_addr <= 'b0;
                link_addr   <= 'b0;
                load        <= 0;
                load_F      <= 0;
            end
            
        endcase
    end
    
endmodule
