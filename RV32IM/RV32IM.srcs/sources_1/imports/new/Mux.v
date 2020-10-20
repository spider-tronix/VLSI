`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2020 04:39:08 AM
// Design Name: 
// Module Name: Mux
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


module Mux #(parameter XLEN =32)
            
            (input [XLEN-1:0] d0,d1,
             input select,
             output reg [XLEN-1:0] d_out
            );
initial          
d_out[XLEN-1:0] <= select ? d1[XLEN-1:0]:d0[XLEN-1:0] ;

endmodule
