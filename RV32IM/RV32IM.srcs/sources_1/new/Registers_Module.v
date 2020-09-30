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

module Registers_Module(clk,ind_1,ind_2,Reg_Rd_En,Reg_Wt_En,D_in,D_out_1,D_out_2);
parameter XLEN = 32;
input [4:0] ind_1,ind_2;
input wire Reg_Rd_En,Reg_Wt_En,clk;
input [31:0] D_in;
output reg [31:0] D_out_1,D_out_2;
reg [XLEN-1:0] x[0:31];
always @(posedge clk)
begin
 if(Reg_Rd_En)
    begin
        assign D_out_1 = x[ind_1];
        assign D_out_2 = x[ind_2];
    end
 else
 if(Reg_Wt_En)
    begin
        x[ind_1] <= D_in ;
        x[0] <= 0;
    end
 begin
 end
end
endmodule
