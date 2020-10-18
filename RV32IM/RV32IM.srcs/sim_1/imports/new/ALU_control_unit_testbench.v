`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2020 14:18:58
// Design Name: 
// Module Name: ALU_control_unit_testbench
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


module ALU_control_unit_testbench;
//input
    reg [1:0] ALUOp;
    reg [6:0] funct7;
    reg [2:0] funct3;
    reg ALU_control_enable,clk;
    //output
    wire [3:0] ALU_control_line;
    //parameter
    integer i;
    //uut
    ALU_control uut(.ALUOp(ALUOp),.funct7(funct7),.funct3(funct3),.ALU_control_line(ALU_control_line),.ALU_control_enable(ALU_control_enable),.clk(clk));
    
    initial begin
    ALU_control_enable = 1;
    clk = 0;
    i=2;
    while(i!=0)
    begin
    #5 ALUOp = 2'b00;
    #10 ALUOp = 2'b01;
    #15 
    ALUOp = 2'b10;
    funct7 = 7'b0000000;
    funct3 = 3'b000;
    #20 funct7 = 7'b0100000;
    #25 ALU_control_enable = 0;
    ALUOp = 2'b00;
    #30 ALU_control_enable = 1;
    i = i-1;
    end
    end
always
#10 clk = ~clk;
endmodule

