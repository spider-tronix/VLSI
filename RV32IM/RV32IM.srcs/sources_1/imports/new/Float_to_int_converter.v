`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.02.2021 12:50:48
// Design Name: 
// Module Name: Float_to_int_converter
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


module Float_to_int_converter#(parameter XLEN = 32)(input enable, input float_to_int, input sign, input [XLEN-1:0] data, output reg [XLEN-1:0] result_conv);
reg [23:0] mantissa;
reg [7:0] exponent;
reg [8:0] exp_unbiased;
reg [7:0] exp_2s_complement;
always@(*)
begin 
    if(float_to_int)
    begin 
        if(sign)
        begin
            result_conv[31] = data[31];
            exponent = data[30:23];
            mantissa = data[22:0];
            exp_unbiased = exponent + 8'b10000001; //2's complement of bias term 127
            if(exp_unbiased[8]) //carry is present => exponent is positive; 
                begin
                exp_unbiased = exp_unbiased - 1; // 1.M * 2^(exp-127) = 1M * 2^((exp-127) - 1)
                result_conv[30:0] = ({1,mantissa}<<exp_unbiased);
                end
            else begin 
                exp_2s_complement = ~(exp_unbiased[7:0]-1'b1); //2's complement
                exp_2s_complement = exp_2s_complement -1; // 1.M * 2^(exp-127) = 1M * 2^((exp-127) - 1)
                result_conv[30:0] = ({1,mantissa}>>exp_2s_complement); //
            end
        end
        else if(sign==0) begin
            exponent = data[30:23];
            mantissa = data[22:0];
            exp_unbiased = exponent + 8'b10000001; //2's complement of bias term 127
            if(exp_unbiased[8]) //carry is present => exponent is positive; 
                begin
                exp_unbiased = exp_unbiased - 1; // 1.M * 2^(exp-127) = 1M * 2^((exp-127) - 1)
                result_conv[31:0] = ({1,mantissa}<<exp_unbiased);
                end
            else begin 
                exp_2s_complement = ~(exp_unbiased[7:0]-1'b1); //2's complement
                exp_2s_complement = exp_2s_complement -1; // 1.M * 2^(exp-127) = 1M * 2^((exp-127) - 1)
                result_conv[31:0] = ({1,mantissa}>>exp_2s_complement); //
            end
        end
    end
    
    else begin 
    
    end
end                    

endmodule
