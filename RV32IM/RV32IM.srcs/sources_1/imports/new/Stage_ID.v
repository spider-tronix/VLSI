`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akhil M
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
               input clk,
               input DecoderEnable,
               output reg [6:0] opcode,
               output reg [2:0] funct3,
               output reg [6:0] funct7,
               output reg [4:0] src1,src2,dest,
               output reg [31:0] imm);

initial 
begin 
  opcode <= 7'bZ;
end
            
always @(posedge clk)
begin
    if(DecoderEnable)
    begin
        opcode <= IR[6:0];
        case(IR[6:0])
        `OP_OP:
                begin
                    src1 <= IR[19:15];
                    src2 <= IR[24:20];
                    dest <= IR[11:7];
                    funct3 <= IR[14:12]; 
                    funct7 <= IR[31:25];
                    imm <= 'b0;
                end
        `OP_OP_IMM:
                begin
                    src1 <= IR[19:15];
                    src2 <= 'bz;
                    dest <= IR[11:7];
                    funct3 <= IR[14:12]; 
                    funct7 <= 'b0;
                    imm <= {{20{IR[31]}},IR[31:20]};
                end
        `OP_LUI:
                begin
                    src1 <= 'bz;
                    src2 <= 'bz;
                    dest <= IR[11:7];
                    funct3 <= 'b0;
                    funct7 <= 'b0;
                    imm <= {IR[31:12],{12{1'b0}}};
                end
        `OP_AUIPC:
                begin
                    src1 <= 'bz;
                    src2 <= 'bz;
                    dest <= IR[11:7];
                    funct3 <= 'b0;
                    funct7 <= 'b0;
                    imm <= {IR[31:12],{12{1'b0}}};
                end
        `OP_JAL:
                begin
                    src1 <= 'bz;
                    src2 <= 'bz;
                    dest <= IR[11:7];
                    funct3 <= 'b0;
                    funct7 <= 'b0;
                    imm <= {{20{IR[31]}},IR[20],IR[30:21],1'b0};
                end  
        `OP_JALR:
                begin
                    src1 <= IR[19:15];
                    src2 <= 'bz;
                    dest <= IR[11:7];
                    funct3 <= IR[14:12];
                    funct7 <= 'b0;
                    imm <= IR[31:20];
                end
        `OP_BRANCH:
                begin
                    src1 <= IR[19:15];
                    src2 <= IR[24:20];
                    dest <= 'bz;
                    funct3 <= IR[14:12];
                    funct7 <= 'b0;
                    imm <= {{20{IR[31]}},IR[7],IR[30:25],IR[11:8],1'b0};
                end
        `OP_LOAD:
                begin
                    src1 <= IR[19:15];
                    src2 <= 'bz;
                    dest <= IR[11:7];
                    funct3 <= IR[14:12];
                    funct7 <= 'b0;
                    imm <= {{20{{IR[31]}}},IR[31:20]};
                end
        `OP_STORE:
                begin
                    src1 <= IR[19:15];
                    src2 <= IR[24:20];
                    dest <= 'bz;
                    funct3 <= IR[14:12];
                    funct7 <= 'b0;
                    imm <= {{20{{IR[31]}}},IR[31:25],IR[11:7]};
                end
        default : ;
        endcase 
    end
end
endmodule
