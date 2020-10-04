`timescale 1ns / 1ps

module RAM_Module #(parameter WORDLENGTH = 8,
                    parameter XLEN = 32,
                    parameter IMMEDIATE = 12,
                    parameter Size = 2048)
                    
                   (input [XLEN-1:0] Addr,
                    input [IMMEDIATE-1:0] Offset_Imm, 
                    input [XLEN-1:0] Data_In,
                    input Rd_En,Wt_En,RAM_Enable,clk,
                    output reg [XLEN-1:0] Data_Out);
                     
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
