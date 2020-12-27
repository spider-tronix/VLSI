`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name: Stage_ID
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
module Stage_ID(input [31:0] IR,
                input DecoderEnable,
                input wire rst,
                input wire [31:0] regdata1, regdata2,
                // Forwarding 
                input wire MEM_reg_write,
                input wire [31:0] MEM_data,
                input wire [4:0] MEM_dest,
                input wire EX_reg_write,
                input wire [31:0] EX_data,
                input wire [4:0] EX_dest,
                input wire EX_load,
                output reg [6:0] opcode,
                output reg [2:0] funct3,
                output reg [6:0] funct7,
                output reg [4:0] src1,
                src2,
                dest,
                output reg [31:0] imm,
                output wire stallreq,
                output reg [31:0]data1,
                data2);

initial
begin
    opcode <= 0;
end
reg stallreq_1, stallreq_2;
reg re1, re2;
assign stallreq = stallreq_1 || stallreq_2;
always @(*)
begin
    if(rst) begin 
        src1   <= 0;
        src2   <= 0;
        dest   <= 0;
        funct3 <= 0;
        funct7 <= 0;
        imm    <= 0;
        re1    <= 0;
        re2    <= 0;
        opcode <= 0;
    end 
    else if (DecoderEnable) begin
        opcode <= IR[6:0];
        case(IR[6:0])
            `OP_OP:
            begin
                src1   <= IR[19:15];
                src2   <= IR[24:20];
                dest   <= IR[11:7];
                funct3 <= IR[14:12];
                funct7 <= IR[31:25];
                imm    <= 'b0;
                re1    <= 1;
                re2    <= 1;
            end
            `OP_OP_IMM:
            begin
                src1   <= IR[19:15];
                src2   <= 'bz;
                dest   <= IR[11:7];
                funct3 <= IR[14:12];
                funct7 <= 'b0;
                imm    <= {{20{IR[31]}},IR[31:20]};
                re1    <= 1;
                re2    <= 0;
            end
            `OP_LUI:
            begin
                src1   <= 'bz;
                src2   <= 'bz;
                dest   <= IR[11:7];
                funct3 <= 'b0;
                funct7 <= 'b0;
                imm    <= {IR[31:12],{12{1'b0}}};
                re1    <= 0;
                re2    <= 0;
            end
            `OP_AUIPC:
            begin
                src1   <= 'bz;
                src2   <= 'bz;
                dest   <= IR[11:7];
                funct3 <= 'b0;
                funct7 <= 'b0;
                imm    <= {IR[31:12],{12{1'b0}}};
                re1    <= 0;
                re2    <= 0;
            end
            `OP_JAL:
            begin
                src1   <= 'bz;
                src2   <= 'bz;
                dest   <= IR[11:7];
                funct3 <= 'b0;
                funct7 <= 'b0;
                imm    <= {IR[31], IR[19:12], IR[20], IR[30:21]};
                re1    <= 0;
                re2    <= 0;
            end
            `OP_JALR:
            begin
                src1   <= IR[19:15];
                src2   <= 'bz;
                dest   <= IR[11:7];
                funct3 <= IR[14:12];
                funct7 <= 'b0;
                imm    <= IR[31:20];
                re1    <= 1;
                re2    <= 0;
            end
            `OP_BRANCH:
            begin
                src1   <= IR[19:15];
                src2   <= IR[24:20];
                dest   <= 'bz;
                funct3 <= IR[14:12];
                funct7 <= 'b0;
                imm    <= {{20{IR[31]}},IR[7],IR[30:25],IR[11:8],1'b0};
                re1    <= 1;
                re2    <= 1;
            end
            `OP_LOAD:
            begin
                src1   <= IR[19:15];
                src2   <= 'bz;
                dest   <= IR[11:7];
                funct3 <= IR[14:12];
                funct7 <= 'b0;
                imm    <= {{20{{IR[31]}}},IR[31:20]};
                re1    <= 1;
                re2    <= 0;
            end
            `OP_STORE:
            begin
                src1   <= IR[19:15];
                src2   <= IR[24:20];
                dest   <= 'bz;
                funct3 <= IR[14:12];
                funct7 <= 'b0;
                imm    <= {{20{{IR[31]}}},IR[31:25],IR[11:7]};
                re1    <= 1;
                re2    <= 1;
            end
            default :
            ;
        endcase
    end
end


`define SET_output(opv, re, reg_addr, reg_data, imm, stallreq) \
    stallreq = 0; \
    if(rst) begin \
        opv = 0; \
    end else if (re && EX_load && (EX_dest == reg_addr)) begin \
        stallreq = 1; \
    end else if (re && EX_reg_write && (EX_dest == reg_addr)) begin \
        opv = EX_data; \
    end else if (re && MEM_reg_write && (MEM_dest == reg_addr)) begin \
        opv = MEM_data; \
    end else if (re) begin \
        opv = reg_data; \
    end else if (!re) begin \
        opv = imm; \
    end else begin \
        opv = 0; \
end

always @(*)begin
    `SET_output(data1, re1, src1, regdata1, 0, stallreq_1)
end
always @(*)begin
    `SET_output(data2, re2, src2, regdata2, imm, stallreq_2)
end
endmodule
