`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.12.2020 11:27:25
// Design Name: 
// Module Name: PC
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


module PC #(
parameter XLEN = 32)(input clk, input[4:0] current_stage, input imm, input jump, input branch, input[XLEN-1:0] ALU_result, output reg [XLEN-1:0] PC, output reg [XLEN-1:0] PC_addr);
    initial begin 
    PC = -1;
    end
    always @(negedge current_stage[4])
        begin
           PC_addr = PC + {32{imm, 1'b0}}; 
           PC = (jump || (branch & ALU_result[0]))? PC_addr : (PC + 1);
           //PC = PC+1;
        end

endmodule
