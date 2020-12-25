`timescale 1ns / 1ps

module Stage_IF#(parameter XLEN = 32)
                (input [XLEN-1:0]PC,
                 output [XLEN-1:0]Instr,
                 input clk,
                 select);
    
    ROM_Module fetch_instr(
    .Addr(PC), .Instr(Instr),
    .ROM_Enable(select),.clk(clk),.ROM_Rst(1'b0)
    );
    
endmodule
