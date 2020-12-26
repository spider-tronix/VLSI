`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/24/2020 04:01:59 PM
// Design Name:
// Module Name: reg_EX_MEM
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


module reg_EX_MEM#(parameter XLEN = 32,
                   parameter WORDLENGTH = 8)
                  (input wire clk,
                   rst,
                   input wire [5:0] stall,
                   input wire [4:0] EX_dest,
                   input wire [XLEN-1:0] EX_Addr,
                   input wire [XLEN-1:0] EX_data_i,
                   input wire [2:0] EX_funct3,
                   input wire EX_mem_read,
                   EX_mem_write,
                   EX_mem_to_reg,
                   EX_jump,
                   output reg [4:0] MEM_dest,
                   output reg [XLEN-1:0] MEM_Addr,
                   output reg [XLEN-1:0] MEM_data_i,
                   output reg [2:0] MEM_funct3,
                   MEM_mem_to_reg,
                   output reg MEM_mem_read,
                   MEM_jump,
                   MEM_mem_write);
    always @ (posedge clk) begin
        if (rst || (stall[3] && !stall[4])) begin
            MEM_Addr       <= 0;
            MEM_data_i     <= 0;
            MEM_funct3     <= 0;
            MEM_mem_read   <= 0;
            MEM_mem_write  <= 0;
            MEM_dest       <= 0;
            MEM_mem_to_reg <= 0;
            MEM_jump       <= 0;
            end else if (!stall[3]) begin
            MEM_Addr       <= EX_Addr;
            MEM_data_i     <= EX_data_i;
            MEM_funct3     <= EX_funct3;
            MEM_mem_read   <= EX_mem_read;
            MEM_mem_write  <= EX_mem_write;
            MEM_dest       <= EX_dest;
            MEM_mem_to_reg <= EX_mem_to_reg;
            MEM_jump       <= EX_jump;
        end
    end
endmodule
