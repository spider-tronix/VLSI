 
/* 
Module Name: ALU_Module
Description: Takes two registers as input and 
             performs arithmetic and logical operations at positve clock edge 
             depending on ALU Control input given.
               
 Specifications: Input register size= 32 bits
                 Output register size=  32 bits   
                 AlU Control input=  4 bits
*/
`timescale 1ns / 1ps

module ALU_Module(rs1, rs2, clk, ALU_Enable, ALU_Control, ALU_Reset, result,zero);

parameter XLEN= 32; 
parameter CONTROL_SIZE = 4;

input clk, ALU_Enable, ALU_Reset;
input [XLEN-1:0] rs1,rs2;
input [CONTROL_SIZE-1:0] ALU_Control; //To select functionality
output reg[XLEN-1:0] result;
output zero;

assign zero = (result==0)?1'b1:1'b0; //zero is true if result is zero
always @(posedge clk, rs1, rs2)
begin
      if(ALU_Reset)
          result <= 0;
       else
     if(ALU_Enable)
     begin
     case (ALU_Control)
     4'b0000: result <= rs1 & rs2;            //AND
     4'b0001: result <= rs1 | rs2;            //OR
     4'b0010: result <= ~(rs1|rs2);           //NOR
     4'b0011: result <= rs1 ^ rs2;            //XOR
     4'b0100: result <= rs1 << rs2;           //Left Shift
     4'b0101: result <= rs1 >> rs2;           //Right Shift
     4'b0110: result <= rs1 + rs2;            // Add
     4'b0111: result <= rs1 - rs2;            //Subtract
     4'b1000: result <= (rs1 <rs2) ? 1 : 0;   //Set when Less than (slt)
     default: result <= rs1 + rs2;
     endcase
     end
end
endmodule
