`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2020 19:13:06
// Design Name: 
// Module Name: RV32Core_jump_intr_testbench
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


module RV32Core_jump_intr_testbench;
    parameter XLEN=32;
    reg clk, ALU_Reset;
    //reg [XLEN-1:0] PC;
    wire [XLEN-1:0] result;
  
    
    RV32Core uut(.clk(clk), .ALU_Reset(ALU_Reset), .ALU_result(result));
    
    initial begin
    #100
    clk=0;
    //PC = 32'b00000000000000000000000000000000;
    ALU_Reset=0;
    end
    
    always 
    #10 clk = ~clk;
    
    //always@(negedge current_stage[4])
    //begin
    //PC = PC+1 ;
    //end
endmodule
