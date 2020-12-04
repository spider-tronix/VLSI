`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2020 03:15:27 PM
// Design Name: 
// Module Name: Buffer_32bit
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


module Buffer_32bit #(parameter XLEN = 32)
                     (input [XLEN-1:0] D_in,
                      input clk,
                      output reg [XLEN-1:0] D_out);
                      
always @(negedge clk)
begin
D_out[XLEN-1:0] <= D_in[XLEN-1:0];
end
endmodule
