`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2021 16:21:51
// Design Name: 
// Module Name: Int_to_float_converter
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


module Int_to_float_converter#(parameter XLEN = 32)(input enable, input sign, input[XLEN-1:0] int_data,
                                     output reg [XLEN-1:0] float_result, output reg [7:0] exponent,
                                     output reg [7:0] count, output reg[22:0] mantissa);
reg sign_data; 
reg [XLEN-1:0] int_data_copy; 
//reg[7:0] count;
//reg[7:0] exponent; 
//reg [22:0] mantissa;
always@(*)
begin 
    count = 0;
    if(sign)
    //signed int to float
    begin 
        sign_data = int_data[31];
        float_result[31] = int_data[31];
    end 
    else 
    float_result[31]  =0;
    
        //int_data[31] = 0;
        int_data_copy[31] = 0;
        int_data_copy[30:0] = int_data[30:0];
        while(int_data_copy[31]!=1)
        begin 
            int_data_copy = int_data_copy<<1;
            count = count+1;
        end
        exponent = 8'b10011110 + (~count+1); // 158-count;
        float_result[30:23] = exponent;
        mantissa = int_data_copy[30:8];
        float_result[22:0] = mantissa;
        float_result[31] = sign_data;
end
endmodule
