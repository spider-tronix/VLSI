`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/24/2020 04:01:59 PM
// Design Name:
// Module Name: reg_MEM_WB
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


module reg_MEM_WB#(parameter XLEN = 32)
                  (input wire clk,
                   rst,
                   input wire [5:0] stall,
                   input wire [XLEN-1:0] MEM_data,
                   input wire MEM_wr_enable,
                   input wire [4:0] MEM_register_dest,
                   input wire MEM_wr_enable_F,
                   output reg [XLEN-1:0] WB_data,
                   output reg WB_wr_enable,
                   output reg WB_wr_enable_F,
                   output reg [4:0] WB_dest);
    
    always @ (posedge clk) begin
        if (rst || (stall[4] && !stall[5])) begin
            WB_data      <= 0;
            WB_wr_enable <= 0;
            WB_dest      <= 0;
            WB_wr_enable_F <= 0;
            end else if (!stall[4]) begin
            WB_data      <= MEM_data;
            WB_wr_enable <= MEM_wr_enable;
            WB_dest      <= MEM_register_dest;
            WB_wr_enable_F<= MEM_wr_enable_F;
        end
    end
endmodule
