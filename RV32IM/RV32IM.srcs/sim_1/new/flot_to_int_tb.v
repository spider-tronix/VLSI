`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2021 22:46:52
// Design Name: 
// Module Name: flot_to_int_tb
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


module float_to_int_tb;
    parameter XLEN = 32;
    reg enable, float_to_int,sign;
    reg[XLEN-1:0] input_data;
    wire [XLEN-1:0] output_data;
    wire [22:0] mantissa;
    wire [7:0] exponent;
    wire [8:0] exp_unbiased;
    Float_to_int_converter uut(.enable(enable), .sign(sign), 
                        .data(input_data),.mantissa(mantissa),.exponent(exponent), .exp_unbiased(exp_unbiased), .result_conv(output_data));
    initial begin
    enable = 1;
    float_to_int = 1;
    #10
    input_data = 32'b01000000101100000000000000000000;
    sign = input_data[31];
    #10
    input_data = 32'b11000010010010000000000000000000;
    sign = input_data[31];
    end
endmodule
