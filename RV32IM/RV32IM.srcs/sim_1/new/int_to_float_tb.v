`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2021 16:49:40
// Design Name: 
// Module Name: int_to_float_tb
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


module int_to_float_tb;
parameter XLEN = 32;
reg enable, sign;
reg [XLEN-1:0] int_data;
wire [XLEN-1:0] float_result;
wire [7:0] exponent, count;
wire [22:0] mantissa;
Int_to_float_converter uut(.enable(enable),.sign(sign), .int_data(int_data),
                                     .float_result(float_result), .exponent(exponent),
                                     .count(count), .mantissa(mantissa));
                                     
initial begin 
enable = 1;
sign = 1;
#10 
int_data = 32'b00000000000000000000000000110111; //55
#10 
int_data = 32'b00000000000000000000000000010100; //20
#10 
int_data = 32'b10000000000000000000000000001111; //-15 in signed integer format
end
endmodule
