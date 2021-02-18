`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2021 13:20:05
// Design Name: 
// Module Name: FloatingComparator
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

//This module returns the following 
                                //NaN A B //
//If A>B, result_comp = 010     //0   1 0// 
//If A<B, result_comp = 001 
//If A == b, result_comp = 000
// A = NaN, B != NaN, result_comp = 101 (final result is B)
//A ! = NaN, B == NaN, result_comp = 110 (final result is A)
// A&&B == NaN, result_comp = 111 (final result is NaN)

module FloatingComparator #(parameter FLEN= 32, parameter NaN = 32'h7fc00000)(input enable, input [FLEN-1:0] A, input [FLEN-1:0]B, 
                        output reg [2:0] result_comp);

always@(*)
begin
    if (enable)begin 
        if(A==B)begin
        result_comp <= 'b00;
        end
        
    result_comp = (A[31]>B[31])? 'b001 :(A[31]<B[31])? 'b010 : 'b000; 
                                                          
    if(A[31] == B[31])begin
        result_comp = (A[30:23]>B[30:23])?'b010:'b000;
        if(A[30:23] == B[30:23])begin
        result_comp = (A[22:0] > B[22:0] )? 'b010 : 'b000 ;
        end    
       end
    if(A == NaN && B != NaN)
        result_comp = 'b101; // result = B
    else if(A!= NaN && B == NaN) 
        result_comp = 'b110; //result = A;
    else if(A==NaN && B== NaN)
        result_comp = 'b111; //result = NaN;
    end
end
endmodule
