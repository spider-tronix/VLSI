
`timescale 1ns / 1ps

module ALU_TestBench;

parameter XLEN=32;
parameter CONTROL_SIZE= 4; 
 
//Inputs
reg clk, ALU_Reset, ALU_Enable;
reg [XLEN-1:0] rs1,rs2;
reg [CONTROL_SIZE-1:0] ALU_Control;

//Outputs
wire [XLEN-1:0] result;
wire zero;
integer i; 
//ALU TEST UNIT
ALU_Module uut(
.rs1(rs1),.rs2(rs2),.clk(clk), .ALU_Enable(ALU_Enable),.ALU_Reset(ALU_Reset), .ALU_Control(ALU_Control),
.result(result), .zero(zero)
); 
 
initial  begin
ALU_Enable=1;
clk=0;
ALU_Reset = 0;
for (i=0;i<9; i=i+1)
begin
#10 ALU_Control =4'b0110; rs1 = 8'b00001000; rs2 = 8'b00000010; //Add
#30 ALU_Control= 4'b0111; rs1 = 8'b00001000; rs2 = 8'b00000010; //Subtract
#50 ALU_Control= 4'b0000; rs1 = 8'b00001000; rs2 = 8'b00000010; //AND
#70 ALU_Control= 4'b0001; rs1 = 8'b00001000; rs2 = 8'b00000010; //OR
#90 ALU_Control= 4'b1000; rs1 = 8'b00001000; rs2 = 8'b00000010; // Set when Less than
end
end

//Clock
always
begin
clk=~clk;
#20;
end

endmodule
