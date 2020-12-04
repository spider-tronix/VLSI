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
initial
                       begin
                           case(funct3[1:0])
                           2'b00: begin
                                  
                                  end
                           2'b01: begin
             
                                  end
                           2'b10: begin
                                                
                                  end
                           endcase
                       end
    
endmodule
