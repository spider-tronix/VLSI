`timescale 1ns / 1ps

module FloatingDivision#(parameter XLEN=32)
                        (input [XLEN-1:0]A,
                         input [XLEN-1:0]B,
                         input enable,
                         output overflow,
                         output underflow,
                         output exception,
                         output [XLEN-1:0] result);
                         
reg [23:0] A_Mantissa,B_Mantissa;
reg [22:0] Mantissa;
wire [7:0] exp;
reg [23:0] Temp_Mantissa;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
wire [7:0] Exponent;
reg [7:0] A_adjust,B_adjust;
reg A_sign,B_sign,Sign;
reg [32:0] Temp;
wire [31:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7,debug;
wire [31:0] reciprocal;
wire [31:0] x0,x1,x2,x3;
reg [6:0] exp_adjust;
reg [XLEN-1:0] B_scaled; 
reg en1,en2,en3,en4,en5;
reg dummy;
/*----Initial value----*/
FloatingMultiplication M1(.A({{1'b0,8'd126,B[22:0]}}),.B(32'h3ff0f0f1),.clk(clk),.result(temp1), .enable(enable)); //verified
assign debug = {1'b1,temp1[30:0]};
FloatingAddition A1(.subract_A(0), .subract_B(0), .A(32'h4034b4b5),.B({1'b1,temp1[30:0]}),.result(x0), .enable(enable));

/*----First Iteration----*/
FloatingMultiplication M2(.A({{1'b0,8'd126,B[22:0]}}),.B(x0),.clk(clk),.result(temp2), .enable(enable));
FloatingAddition A2(.subract_A(0), .subract_B(0), .A(32'h40000000),.B({!temp2[31],temp2[30:0]}),.result(temp3), .enable(enable));
FloatingMultiplication M3(.A(x0),.B(temp3),.clk(clk),.result(x1), .enable(enable));

/*----Second Iteration----*/
FloatingMultiplication M4(.A({1'b0,8'd126,B[22:0]}),.B(x1),.clk(clk),.result(temp4), .enable(enable));
FloatingAddition A3(.subract_A(0), .subract_B(0), .A(32'h40000000),.B({!temp4[31],temp4[30:0]}),.result(temp5), .enable(enable));
FloatingMultiplication M5(.A(x1),.B(temp5),.clk(clk),.result(x2), .enable(enable));

/*----Third Iteration----*/
FloatingMultiplication M6(.A({1'b0,8'd126,B[22:0]}),.B(x2),.clk(clk),.result(temp6), .enable(enable));
FloatingAddition A4(.subract_A(0), .subract_B(0), .A(32'h40000000),.B({!temp6[31],temp6[30:0]}),.result(temp7), .enable(enable));
FloatingMultiplication M7(.A(x2),.B(temp7),.clk(clk),.result(x3), .enable(enable));

/*----Reciprocal : 1/B----*/
assign Exponent = x3[30:23]+8'd126-B[30:23];
assign reciprocal = {B[31],Exponent,x3[22:0]};

/*----Multiplication A*1/B----*/
FloatingMultiplication M8(.A(A),.B(reciprocal),.clk(clk),.result(result), .enable(enable));
endmodule
