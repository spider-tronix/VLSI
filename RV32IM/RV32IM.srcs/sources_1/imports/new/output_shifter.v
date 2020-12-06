`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2020 12:18:26 AM
// Design Name: 
// Module Name: output_shifter
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


module output_shifter#(parameter XLEN = 32)
                      (input [XLEN-1:0] data_in,
                       input [2:0] funct3,
                       input [1:0] Addr,
                       output reg [XLEN-1:0] data_out
                       );
                       
always @(*)
       begin
           case(funct3[2:0])
           3'b000: 
                  data_out = (Addr[1:0] == 2'b00) ? {{24{data_in[7]}},{data_in[7:0]}} :
                              (Addr[1:0] == 2'b01) ? {{24{data_in[15]}},{data_in[15:8]}} :
                              (Addr[1:0] == 2'b10) ? {{24{data_in[23]}},{data_in[23:16]}} :
                              (Addr[1:0] == 2'b11) ? {{24{data_in[31]}},{data_in[31:24]}} :32'b0;   
           3'b100:
                  data_out = (Addr[1:0] == 2'b00) ? {24'b0,{data_in[7:0]}} :
                              (Addr[1:0] == 2'b01) ? {24'b0,{data_in[15:8]}} :
                              (Addr[1:0] == 2'b10) ? {24'b0,{data_in[23:16]}} :
                              (Addr[1:0] == 2'b11) ? {24'b0,{data_in[31:24]}} :32'b0;
           3'b001:
                  data_out = (Addr[1:0] == 2'b00) ? {{16{data_in[15]}},{data_in[15:0]}} :
                              (Addr[1:0] == 2'b10) ? {{16{data_in[31]}},{data_in[31:16]}} : 32'b0 ;       
           3'b101:
                  data_out = (Addr[1:0] == 2'b00) ? {16'b0,{data_in[15:0]}} :
                              (Addr[1:0] == 2'b10) ? {16'b0,{data_in[31:16]}} : 32'b0 ;                      
           3'b010:
                  data_out = data_in;
                                                      
           endcase
       end

endmodule
