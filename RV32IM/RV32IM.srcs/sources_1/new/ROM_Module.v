/*
Module Name: ROM_Module
Description : Serves as the Program ROM memory from which instructions 
              are fetched every clk cycle
Specifications : Word size = 8 bits
                 Depth = 2048
                 Total Size = 2KB
*/
`timescale 1ns / 1ps

module ROM_Module #(parameter WORD_LENGTH = 8,
                    parameter ROM_DEPTH = 2048,
                    parameter XLEN = 32)
                    
                   (output reg [XLEN-1:0] Instr,
                    input [XLEN-1:0] Addr,
                    input wire ROM_Enable,clk,ROM_Rst);
                    
reg [WORD_LENGTH-1:0] ROM_mem[0:ROM_DEPTH-1]; 
integer i;

//Rom Write Block
initial
begin
 //$readmemb("File path", ROM_mem);           
 //ROM_mem[0] = 8'hff;
 //ROM_mem[1] = 8'hff;
 //
end  
//Rom Read Block

always @(posedge clk)
begin
    if(ROM_Rst)
        for(i = 0;i<ROM_DEPTH;i=i+1)
        ROM_mem[i] <= 0; 
    else
    if(ROM_Enable)
        Instr <= {ROM_mem[Addr+3],ROM_mem[Addr+2],ROM_mem[Addr+1],ROM_mem[Addr]};   //little endian format
    else
        Instr <= 0;
end

endmodule
