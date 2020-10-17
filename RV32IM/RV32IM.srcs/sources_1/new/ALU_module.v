 
/* 
Module Name: ALU_Module
Description: Takes two registers as input and 
             performs arithmetic and logical operations at positve clock edge 
             depending on ALU Control input given.
               
 Specifications: Input register size= 32 bits
                 Output register size=  32 bits   
                 AlU Control input=  4 bits
*/
`include "defines.v"
`timescale 1ns / 1ps

module ALU_Module #(parameter XLEN= 32, 
                    parameter ALU_SELECT_SIZE = 5)

                    (input[XLEN-1:0] rs1,rs2,
                    input clk,ALU_Reset,ALU_Enable,
                    input [ALU_SELECT_SIZE-1:0] AluOp, 
                    output reg[XLEN-1:0]result,
                    output zero);

assign zero = (result==0)?1'b1:1'b0; //zero is true if result is zero
always @(posedge clk, rs1, rs2)
    begin
        if(ALU_Reset)
            result <= 0;
        else
    
        if(ALU_Enable)
        begin
        case (AluOp)
        `EXE_NOP_OP: ;                             //No operation
        `EXE_AND_OP: result <= rs1 & rs2;          //AND
        `EXE_OR_OP : result <= rs1 | rs2;          //OR
        `EXE_XOR_OP: result <= rs1 ^ rs2;          //XOR
     
        `EXE_SLL_OP: result <= rs1 << rs2;         //Left Shift
        `EXE_SRL_OP: result <= rs1 >> rs2;         //Right Shift
     
        `EXE_ADD_OP: result <= rs1 + rs2;              // Add
        `EXE_SUB_OP: result <= rs1 - rs2;            //Subtract
        `EXE_SLT_OP: result <= (rs1 <rs2) ? 1 : 0;   //Set when Less than (slt)
        default: result <= rs1+1;
        endcase
        end
    end
endmodule
