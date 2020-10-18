`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2020 03:06:32 PM
// Design Name: 
// Module Name: Decoder
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
module Decoder(input [31:0] IR,
               input clk,
               input DecoderEnable,
               output reg [6:0] opcode,
               output reg [2:0] funct3,
               output reg [6:0] funct7,
               output reg [4:0] src1,src2,dest,
               output reg [31:0] imm);
               
always @(posedge clk)
begin
    if(DecoderEnable)
    begin
        opcode <= IR[6:0];
        case(opcode)
        `OP_OP:
               begin
                    src1 <= IR[19:15];
                    src2 <= IR[24:20];
                    dest <= IR[11:7];
                    funct3 <= IR[14:12]; 
                    funct7 <= IR[31:25];
                    imm <= 'bz;
               end
        `OP_OP_IMM:
               begin
                    src1 <= IR[19:15];
                    src2 <= 'bz;
                    dest <= IR[11:7];
                    funct3 <= IR[14:12]; 
                    funct7 <= 'bz;
                    imm <= {20*{IR[31]},IR[31:20]};
               end
        default : ;
        endcase 
    end
end
endmodule
