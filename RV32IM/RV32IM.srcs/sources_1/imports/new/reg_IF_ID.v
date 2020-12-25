`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/24/2020 04:01:59 PM
// Design Name:
// Module Name: reg_IF_ID
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


module reg_IF_ID#(parameter XLEN = 32)
                 (input wire clk,
                  input wire rst,
                  input wire branch,
                  input wire [5:0] stall,
                  input [XLEN-1:0]IF_instr,
                  output reg [XLEN-1:0]ID_instr);
    always @ (posedge clk) begin
        if (rst || branch || (stall[1] && !stall[2])) begin
            ID_instr <= 0;
            end else if (!stall[1]) begin
            ID_instr <= ID_instr;
        end
    end
endmodule
