/*
Module Name: ROM_Module
Description : Serves as the Program ROM memory from which instructions 
              are fetched 
Specifications : Word size = 8 bits
                 Depth = 2048
                 Total Size = 2KB
*/
`timescale 1ns / 1ps

module ROM_Module #(parameter WORD_LENGTH = 32,
                    parameter ROM_DEPTH = 2048,
                    parameter XLEN = 32)
                    (input [XLEN-1:0] Addr, 
                     output reg mem_busy,
                     output reg [XLEN-1:0] Instr,
                     input ROM_Enable,ROM_Rst);


reg [WORD_LENGTH-1:0] ROM_mem[0:ROM_DEPTH-1];                
integer i;

//Rom Write Block
initial
begin
 mem_busy <=0;
 $readmemh("Code.txt", ROM_mem);
 $display("Done Reading!!!!!!");           
end  
//Rom Read Block

always @(*)
begin
    if(ROM_Rst)
        for(i = 0;i<ROM_DEPTH;i=i+1)
        ROM_mem[i] <= 0; 
    else
    if(ROM_Enable) begin
        mem_busy = 1;
        // IR = {ROM_mem[Addr+3],ROM_mem[Addr+2],ROM_mem[Addr+1],ROM_mem[Addr]};   //little endian format
        Instr = ROM_mem[Addr];   //little endian format
        mem_busy = 0; 
        $display("IF Get Inst: %h\n", Instr);
    end
    else begin
        // $display("ROM not ENABLED!");
        Instr = 'b0;
    end
end



endmodule
