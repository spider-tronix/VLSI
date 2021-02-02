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
                input wire [31:0] regdata1,
                regdata2,
                regdata3,
                input wire instr_float,
                input wire MEM_reg_write,
                input wire MEM_reg_write_F,
                input wire [31:0] MEM_data,
                input wire [4:0] MEM_dest,
                input wire MEM_instr_float,
                input wire EX_reg_write,
                input wire EX_reg_write_F,
                input wire [31:0] EX_data,
                input wire [4:0] EX_dest,
                input wire EX_load,
                input wire EX_load_F,
                EX_instr_float,
                output reg [6:0] opcode,
                output reg [2:0] funct3,
                output reg [6:0] funct7,
                output reg [4:0] src1,
                src2,
                src3,
                dest,
                output reg reg_write,
                reg_write_F,
                output reg [31:0] imm,
                output wire stallreq,
                output reg [31:0]data1,
                data2,
                data3,
                data_R,
                output reg re1,
                re2,
                output reg re1_F,
                re2_F,
                re3_F);

initial
begin
    opcode <= 0;
end
reg stallreq_1, stallreq_2, stallreq_3, stallreq_R;
assign stallreq = stallreq_1 || stallreq_2 || stallreq_R || stallreq_3;
always @(*)
begin
    if (rst) begin
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
                src1      <= IR[19:15];
                src2      <= IR[24:20];
                src3      <= 'bz;
                dest      <= IR[11:7];
                funct3    <= IR[14:12];
                funct7    <= IR[31:25];
                imm       <= 'b0;
                re1       <= 1;
                re2       <= 1;
                re1_F     <= 0;
                re2_F     <= 0;
                re3_F     <= 0;
                reg_write <= 1'b1;
            end
            `OP_OP_IMM:
            begin
                src1      <= IR[19:15];
                src2      <= 'bz;
                src3      <= 'bz;
                dest      <= IR[11:7];
                funct3    <= IR[14:12];
                funct7    <= 'b0;
                imm       <= {{20{IR[31]}},IR[31:20]};
                re1       <= 1;
                re2       <= 0;
                re1_F     <= 0;
                re2_F     <= 0;
                re3_F     <= 0;
                reg_write <= 1'b1;
            end
            `OP_LUI:
            begin
                src1      <= 'bz;
                src2      <= 'bz;
                src3      <= 'bz;
                dest      <= IR[11:7];
                funct3    <= 'b0;
                funct7    <= 'b0;
                imm       <= {IR[31:12],{12{1'b0}}};
                re1       <= 0;
                re2       <= 0;
                re1_F     <= 0;
                re2_F     <= 0;
                re3_F     <= 0;
                reg_write <= 1'b1;
            end
            `OP_AUIPC:
            begin
                src1      <= 'bz;
                src2      <= 'bz;
                src3      <= 'bz;
                dest      <= IR[11:7];
                funct3    <= 'b0;
                funct7    <= 'b0;
                imm       <= {IR[31:12],{12{1'b0}}};
                re1       <= 0;
                re2       <= 0;
                re1_F     <= 0;
                re2_F     <= 0;
                re3_F     <= 0;
                reg_write <= 1'b1;
            end
            `OP_JAL:
            begin
                src1      <= 'bz;
                src2      <= 'bz;
                src3      <= 'bz;
                dest      <= IR[11:7];
                funct3    <= 'b0;
                funct7    <= 'b0;
                imm       <= {IR[31], IR[19:12], IR[20], IR[30:21]};
                re1       <= 0;
                re2       <= 0;
                re1_F     <= 0;
                re2_F     <= 0;
                re3_F     <= 0;
                reg_write <= 1'b1;
            end
            `OP_JALR:
            begin
                src1      <= IR[19:15];
                src2      <= 'bz;
                src3      <= 'bz;
                dest      <= IR[11:7];
                funct3    <= IR[14:12];
                funct7    <= 'b0;
                imm       <= IR[31:20];
                re1       <= 1;
                re2       <= 0;
                re1_F     <= 0;
                re2_F     <= 0;
                re3_F     <= 0;
                reg_write <= 1'b1;
            end
            `OP_BRANCH:
            begin
                src1      <= IR[19:15];
                src2      <= IR[24:20];
                src3      <= 'bz;
                dest      <= 'bz;
                funct3    <= IR[14:12];
                funct7    <= 'b0;
                imm       <= {{20{IR[31]}},IR[7],IR[30:25],IR[11:8],1'b0};
                re1       <= 1;
                re2       <= 1;
                re1_F     <= 0;
                re2_F     <= 0;
                re3_F     <= 0;
                reg_write <= 1'b0;
            end
            `OP_LOAD:
            begin
                src1      <= IR[19:15];
                src2      <= 'bz;
                src3      <= 'bz;
                dest      <= IR[11:7];
                funct3    <= IR[14:12];
                funct7    <= 'b0;
                imm       <= {{20{{IR[31]}}},IR[31:20]};
                re1       <= 1;
                re2       <= 0;
                re1_F     <= 0;
                re2_F     <= 0;
                re3_F     <= 0;
                reg_write <= 1'b1;
            end
            `OP_STORE:
            begin
                src1      <= IR[19:15];
                src2      <= IR[24:20];
                src3      <= 'bz;
                dest      <= 'bz;
                funct3    <= IR[14:12];
                funct7    <= 'b0;
                imm       <= {{20{{IR[31]}}},IR[31:25],IR[11:7]};
                re1       <= 1;
                re2       <= 1;
                re1_F     <= 0;
                re2_F     <= 0;
                re3_F     <= 0;
                reg_write <= 1'b0;
            end
            `OP_FLW:
            begin
                src1        <= IR[19:15];
                src2        <= 'bz;
                src3        <= 'bz;
                dest        <= IR[11:7];
                funct3      <= IR[14:12];
                funct7      <= 'b0;
                imm         <= {{20{{IR[31]}}},IR[31:20]};
                re1         <= 0;
                re2         <= 0;
                re1_F       <= 1;
                re2_F       <= 0;
                re3_F       <= 0;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
            end
            `OP_FSW:
            begin
                src1        <= IR[19:15];
                src2        <= IR[24:20];
                src3        <= 'bz;
                dest        <= 'bz;
                funct3      <= IR[14:12];
                funct7      <= 'b0;
                imm         <= {{20{{IR[31]}}},IR[31:25],IR[11:7]};
                re1         <= 0;
                re2         <= 0;
                re1_F       <= 1;
                re2_F       <= 1;
                re3_F       <= 0;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b0;
            end
            `OP_F_OP:
            begin
                src1   <= IR[19:15];
                src2   <= IR[24:20];
                src3   <= 'bz;
                dest   <= IR[11:7];
                funct3 <= IR[14:12];
                funct7 <= IR[31:25];
                imm    <= 'b0;
                re1    <=      (funct7 == `FUNCT7_FCVT_W_S)  ? 0 :
                               (funct7 == `FUNCT7_FCVT_WU_S) ? 0 :
                               (funct7 == `FUNCT7_FMV_X_W)   ? 0 :
                               (funct7 == `FUNCT7_FCLASS_S)  ? 0 :
                               (funct7 == `FUNCT7_FCVT_S_W)  ? 1 :
                               (funct7 == `FUNCT7_FCVT_S_WU) ? 1 :
                               (funct7 == `FUNCT7_FMV_W_X)   ? 1 : 0;
                re2    <= 0;
                re1_F  <=      (funct7 == `FUNCT7_FCVT_W_S)  ? 1 :
                               (funct7 == `FUNCT7_FCVT_WU_S) ? 1 :
                               (funct7 == `FUNCT7_FMV_X_W)   ? 1 :
                               (funct7 == `FUNCT7_FCLASS_S)  ? 1 :
                               (funct7 == `FUNCT7_FCVT_S_W)  ? 0 :
                               (funct7 == `FUNCT7_FCVT_S_WU) ? 0 :
                               (funct7 == `FUNCT7_FMV_W_X)   ? 0 : 1;

                re2_F  <=      (funct7 == `FUNCT7_FCVT_W_S)  ? 0 :
                               (funct7 == `FUNCT7_FCVT_WU_S) ? 0 :
                               (funct7 == `FUNCT7_FMV_X_W)   ? 0 :
                               (funct7 == `FUNCT7_FCLASS_S)  ? 0 :
                               (funct7 == `FUNCT7_FCVT_S_W)  ? 0 :
                               (funct7 == `FUNCT7_FCVT_S_WU) ? 0 :
                               (funct7 == `FUNCT7_FMV_W_X)   ? 0 : 1;
                re3_F       <= 0;
                reg_write   <= (funct7 == `FUNCT7_FCVT_W_S)  ? 1 :
                               (funct7 == `FUNCT7_FCVT_WU_S) ? 1 :
                               (funct7 == `FUNCT7_FMV_X_W)   ? 1 :
                               (funct7 == `FUNCT7_FCLASS_S)  ? 1 :
                               (funct7 == `FUNCT7_FCVT_S_W)  ? 0 :
                               (funct7 == `FUNCT7_FCVT_S_WU) ? 0 :
                               (funct7 == `FUNCT7_FMV_W_X)   ? 0 : 0;

                reg_write_F <= (funct7 == `FUNCT7_FCVT_W_S)  ? 0 :
                               (funct7 == `FUNCT7_FCVT_WU_S) ? 0 :
                               (funct7 == `FUNCT7_FMV_X_W)   ? 0 :
                               (funct7 == `FUNCT7_FCLASS_S)  ? 0 :
                               (funct7 == `FUNCT7_FCVT_S_W)  ? 1 :
                               (funct7 == `FUNCT7_FCVT_S_WU) ? 1 :
                               (funct7 == `FUNCT7_FMV_W_X)   ? 1 : 1;
            end
            `OP_FNMADD_S:
            begin
                src1        <= IR[19:15];
                src2        <= IR[24:20];
                src3        <= IR[31:27];
                dest        <= IR[11:7];
                funct3      <= IR[14:12];
                funct7      <= IR[26:25];
                imm         <= 'b0;
                re1         <= 0;
                re2         <= 0;
                re1_F       <= 1;
                re2_F       <= 1;
                re3_F       <= 1;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
            end
            `OP_FMADD_S:
            begin
                src1        <= IR[19:15];
                src2        <= IR[24:20];
                src3        <= IR[31:27];
                dest        <= IR[11:7];
                funct3      <= IR[14:12];
                funct7      <= IR[26:25];
                imm         <= 'b0;
                re1         <= 0;
                re2         <= 0;
                re1_F       <= 1;
                re2_F       <= 1;
                re3_F       <= 1;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
            end
            `OP_FMSUB_S:
            begin
                src1        <= IR[19:15];
                src2        <= IR[24:20];
                src3        <= IR[31:27];
                dest        <= IR[11:7];
                funct3      <= IR[14:12];
                funct7      <= IR[26:25];
                imm         <= 'b0;
                re1         <= 0;
                re2         <= 0;
                re1_F       <= 1;
                re2_F       <= 1;
                re3_F       <= 1;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
            end
            `OP_FNMSUB_S:
            begin
                src1        <= IR[19:15];
                src2        <= IR[24:20];
                src3        <= IR[31:27];
                dest        <= IR[11:7];
                funct3      <= IR[14:12];
                funct7      <= IR[26:25];
                imm         <= 'b0;
                re1         <= 0;
                re2         <= 0;
                re1_F       <= 1;
                re2_F       <= 1;
                re3_F       <= 1;
                reg_write   <= 1'b0;
                reg_write_F <= 1'b1;
            end
            
            default :
            begin
                src1        <= 'bX;
                src2        <= 'bX;
                src3        <= 'bX;
                dest        <= 'bX;
                funct3      <= 'bX;
                funct7      <= 'bX;
                imm         <= 'bX;
                re1         <= 'bX;
                re2         <= 'bX;
                re1_F       <= 'bX;
                re2_F       <= 'bX;
                re3_F       <= 'bX;
                reg_write   <= 'bX;
                reg_write_F <= 'bX;
            end
        endcase
    end
        end
        
        
        `define SET_output(opv, re, re_F, reg_addr, reg_data, imm, stallreq) \
        stallreq = 0; \
        if (rst) begin \
        opv = 0; \
        end else if ((instr_float == EX_instr_float) && ((EX_load && re) || (EX_load_F && re_F)) && (EX_dest == reg_addr)) begin \
        stallreq = 1; \
        end else if ((instr_float == EX_instr_float) && ((EX_reg_write && re) || (EX_reg_write_F && re_F)) && (EX_dest == reg_addr)) begin \
        opv = EX_data; \
        end else if ((instr_float == MEM_instr_float) && ((MEM_reg_write && re) || (MEM_reg_write_F && re_F)) && (MEM_dest == reg_addr)) begin \
        opv = MEM_data; \
        end else if (re || re_F) begin \
        opv = reg_data; \
        end else if (!(re || re_F)) begin \
        opv = imm; \
        end else begin \
        opv = 0; \
        end
        
        always @(*)begin
            `SET_output(data1, re1, re1_F, src1, regdata1, 0, stallreq_1)
        end
        always @(*)begin
            `SET_output(data2, re2, re2_F, src2, regdata2, imm, stallreq_2)
        end
        always @(*)begin
            `SET_output(data3, 0, re3_F, src3, regdata3, 0, stallreq_3)
        end
        always @(*)begin
            `SET_output(data_R, (!instr_float), instr_float, src2, regdata2, regdata2, stallreq_R)
        end
        
        endmodule
