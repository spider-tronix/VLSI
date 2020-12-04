`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2020 11:41:22 PM
// Design Name: 
// Module Name: input_shifter
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

// 00: //Byte Store and Load
// 01: //Halfword Store and Load
// 10: //Word Store and Load
// For Store Operations
module input_shifter #(parameter XLEN = 32)
                      (input [XLEN-1:0] data_in,
                       input [2:0] funct3,
                       input [1:0] Addr,
                       output reg [XLEN-1:0] data_out
                       );
initial
begin
    case(funct3[1:0])
    2'b00: begin
           data_out <= (Addr[1:0] == 2'b00) ? {24'b0,{data_in[7:0]}} :
                       (Addr[1:0] == 2'b01) ? {16'b0,{data_in[7:0]},8'b0} :
                       (Addr[1:0] == 2'b10) ? {8'b0,{data_in[7:0]},16'b0} :
                       (Addr[1:0] == 2'b11) ? {{data_in[7:0]},24'b0} : 32'b0;
           end
    2'b01: begin
           data_out <= (Addr[1:0] == 2'b00) ? {16'b0,{data_in[15:0]}} :
                       (Addr[1:0] == 2'b01) ? {{data_in[15:0]},16'b0} : 32'b0 ;          
           end
    2'b10: begin
           data_out <= data_in;                    
           end
    endcase
end
endmodule
