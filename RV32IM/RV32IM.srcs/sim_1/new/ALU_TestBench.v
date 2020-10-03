
`timescale 1ns / 1ps

module ALU_TestBench;

parameter XLEN=32;
parameter ALU_SELECT_SIZE= 5; 
 
//Inputs
reg clk, ALU_Reset, ALU_Enable;
reg [XLEN-1:0] rs1,rs2;
reg [ALU_SELECT_SIZE-1:0] AluOp;

//Outputs
wire [XLEN-1:0] result;
wire zero;
integer i; 
//ALU TEST UNIT
ALU_Module uut(
.rs1(rs1),.rs2(rs2),.clk(clk), .ALU_Enable(ALU_Enable),.ALU_Reset(ALU_Reset), .AluOp(AluOp),
.result(result), .zero(zero)
); 
 
initial  begin
ALU_Enable=1;
clk=0;
ALU_Reset = 0;
for (i=0;i<9; i=i+1)
begin
#10 AluOp=8; rs1 = 32'b00001000; rs2 = 32'b00000010; //Add
#15 AluOp= 11; rs1 = 32'b00001000; rs2 = 32'b00000010; //Subtract
#20 AluOp= 1; rs1 = 32'b00001000; rs2 = 32'b00000010; //AND
#25 AluOp= 3; rs1 = 32'b00001000; rs2 = 32'b00000001; //XOR
#30 AluOp= 5; rs1 = 32'b00000100; rs2 = 32'b00000010; // Left shift
end
end

//Clock
always
begin
clk=~clk;
#10;
end

endmodule
