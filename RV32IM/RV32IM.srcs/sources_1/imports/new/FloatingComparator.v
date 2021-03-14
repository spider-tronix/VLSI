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

reg SNAN_A = 0,QNAN_A = 0, SNAN_B=0, QNAN_B=0;
reg[FLEN-1:0] A_NaN, B_NaN;
always@(*)
begin
    A_NaN <=0;
    B_NaN <=0;
    //Checking for both signalling and quiet NaN and assigning it as NaN = 32'h7fc00000
    SNAN_A <= (32'h7F800001<=A<= 32'h7FBFFFFF || 32'hFF800001<= A<= 32'hFFBFFFFF);
    QNAN_A <= (32'h7FC00000<=A<=32'h7FFFFFFF || 32'hFFC00000<=A<=32'hFFFFFFFF);
    SNAN_B <= (32'h7F800001<=B<= 32'h7FBFFFFF || 32'hFF800001<= B<= 32'hFFBFFFFF);
    QNAN_B <= (32'h7FC00000<=B<=32'h7FFFFFFF || 32'hFFC00000<=B<=32'hFFFFFFFF);
    
    if(SNAN_A == 1 || QNAN_A ==1) 
        A_NaN <= `NaN;
        
    if(SNAN_B == 1 || QNAN_B ==1) 
        B_NaN <= `NaN;
     // comparison cases   
    if (enable)begin 
        if(A==B && A_NaN!=`NaN && B_NaN!= `NaN)
        begin
        result_comp <= 'b00;
        end
        
    result_comp = (A[31]>B[31])? 'b001 :(A[31]<B[31])? 'b010 : 'b000; 
                                                          
    if(A[31] == B[31])begin
        result_comp = (A[30:23]>B[30:23])?'b010:'b000;
        if(A[30:23] == B[30:23])begin
        result_comp = (A[22:0] > B[22:0] )? 'b010 :'b000 ;
        end    
       end   
    if(A_NaN == `NaN && B_NaN != `NaN)
        result_comp = 'b101; // result = B
    else if(A_NaN!= `NaN && B_NaN == `NaN) 
        result_comp = 'b110; //result = A;
    else if(A_NaN==`NaN && B_NaN == `NaN)
        result_comp = 'b111; //result = NaN;
    end
end
endmodule
