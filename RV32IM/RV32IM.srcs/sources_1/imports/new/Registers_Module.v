///////////////////////////////////////////////////////
/*
Module Name: Registers_Module
Description : The internal 32 registers described in the RISC V Architecture. 
              
              Read Mode : two registers can be read at the same time, Index 
              specified by ind_1 and ind_2 and output stored in D_out_1 and
              D_out_2 if Reg_Rd_En is HIGH 
              
              Write Mode: single register can be written by specifying the
              first index ind_1 (ind_2 is ignored).The value from D_in is 
              stored in the register specified by the index
              
              Note: x0 is hard-wired to 0 as per the RISC-V architecture 
Specifications : Word size = 32 bits
                 
*/
`timescale 1ns / 1ps

module Registers_Module #(parameter XLEN = 32,
                          parameter RegBank_Size = 32)
                         
                         (input [4:0] src1,src2,dest,
                          input wire re,re1,re2,we,clk,
                          input [XLEN-1:0] rd,
                          output reg [XLEN-1:0] rs1,rs2 );
                          
reg [XLEN-1:0] x[0:RegBank_Size-1];
integer i;
initial 
begin
x[0] <= 0; //register 0 hardwired to zero
for(i=1;i<RegBank_Size;i=i+1)
    begin 
        if(i==2)
        begin
        x[i] <= 32'h0000ffff;
        end
        else
        begin
        x[i] <= i;
        end
    end
end

always @(negedge clk)
begin
 if(re)
    begin
      rs1 <= re1 ? x[src1] : 'bz;
      rs2 <= re2 ? x[src2] : 'bz;
    end
end

always @(posedge clk)
begin
 if(we)
    begin
      x[dest] <= dest ? rd[31:0] : 32'b0 ;
    end
end

endmodule
