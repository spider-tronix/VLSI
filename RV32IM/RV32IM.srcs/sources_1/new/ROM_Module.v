/*
Module Name: ROM_Module
Description : Serves as the Program ROM memory from which instructions 
              are fetched every clk cycle
Specifications : Word size = 32 bits
                 Depth = 512
                 Total Size = 2KB
*/
`timescale 1ns / 1ps



module ROM_Module(Addr,Instr,ROM_Enable,clk,ROM_Rst);
parameter WORD_LENGTH = 32;
parameter ROM_DEPTH = 512;
output reg [WORD_LENGTH-1:0] Instr;
input [WORD_LENGTH-1:0] Addr;
input wire ROM_Enable,clk,ROM_Rst;
reg [WORD_LENGTH-1:0] ROM_mem[0:ROM_DEPTH-1];                // 512*32 = 2KB of ROM memory 
integer i;

//Rom Write Block
initial
begin
 //$readmemb("File path", ROM_mem);           
 //ROM_mem[0] = 32'hffffffff;
 //ROM_mem[1] = 32'hff0ffff0;
end  
//Rom Read Block

always @(posedge clk)
begin
    if(ROM_Rst)
        for(i = 0;i<ROM_DEPTH;i=i+1)
        ROM_mem[i] <= 0; 
    else
    if(ROM_Enable)
        Instr <= ROM_mem[Addr];
    else
        Instr <= 0;
end

endmodule
