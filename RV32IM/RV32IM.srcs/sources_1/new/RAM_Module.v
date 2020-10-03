`timescale 1ns / 1ps

module RAM_Module( Addr,Offset_Imm, Data_In, Data_Out, clk, Rd_En , Wt_En , RAM_Enable );
parameter WORDLENGTH = 8;
parameter XLEN = 32;
parameter IMMEDIATE = 12;
parameter Size = 2048;               //2**61 memory words , Defined as per David patterson Computer Architecture.
input [XLEN-1:0] Addr;
input [IMMEDIATE-1:0] Offset_Imm;
input [XLEN-1:0] Data_In;
input wire Rd_En,Wt_En,RAM_Enable,clk;
output reg [XLEN-1:0] Data_Out;
reg [WORDLENGTH-1:0] RAM_mem[0:Size-1];

always @(posedge clk)
begin
    if(RAM_Enable)
        begin
            if(Rd_En)
                Data_Out <= {RAM_mem[Addr+Offset_Imm+3],RAM_mem[Addr+Offset_Imm+2],RAM_mem[Addr+Offset_Imm+1],RAM_mem[Addr+Offset_Imm]};
            else
            if(Wt_En)
                {RAM_mem[Addr+Offset_Imm+3],RAM_mem[Addr+Offset_Imm+2],RAM_mem[Addr+Offset_Imm+1],RAM_mem[Addr+Offset_Imm]} <= Data_In[31:0];
        end
end

endmodule
