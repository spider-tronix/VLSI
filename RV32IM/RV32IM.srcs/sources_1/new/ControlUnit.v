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

module ControlUnit(
    input[6:0] opcode,
    output reg[1:0] alu_op,
    output reg mem_read,mem_write,alu_src,mem_to_reg,reg_write    
    );


always @(*)
begin
 case(opcode) 
 `OP_OP:  
  begin
      alu_src = 1'b0;
      mem_to_reg = 1'b0;
      reg_write = 1'b1;
      mem_read = 1'b0;
      mem_write = 1'b0;
      alu_op = 2'b10;
   end
  `OP_OP_IMM:  
  begin
      alu_src = 1'b1;
      mem_to_reg = 1'b0;
      reg_write = 1'b1;
      mem_read = 1'b0;
      mem_write = 1'b0;
      alu_op = 2'b10;
   end
  `OP_LOAD:  
  begin
      alu_src = 1'b1;
      mem_to_reg = 1'b1;
      reg_write = 1'b1;
      mem_read = 1'b1;
      mem_write = 1'b0;
      alu_op = 2'b00;
   end
  `OP_STORE:  
  begin
    alu_src = 1'b1;
    mem_to_reg = 1'bX;
    reg_write = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b1;
    alu_op = 2'b00;
   end 

 default: begin
    alu_src = 1'b0;
    mem_to_reg = 1'b0;
    reg_write = 1'b1;
    mem_read = 1'b0;
    mem_write = 1'b0;
    alu_op = 2'b00;
   end
 endcase
 end

endmodule
