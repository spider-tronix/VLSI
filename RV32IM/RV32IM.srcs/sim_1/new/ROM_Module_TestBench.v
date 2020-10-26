`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2020 12:22:41
// Design Name: 
// Module Name: ROM_Module_TestBench
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


module ROM_Module_TestBench;

    reg clk, reset, enable;
    reg [31:0] Addr;
    wire [31:0] result;

    ROM_Module uut(.Addr(Addr), .IR(result), 
                    .ROMEnable(enable), .clk(clk),  .reset(reset) );

    initial begin
        #100;
        clk = 0;
        reset = 0;
        enable = 0;
        Addr = 32'b00000000000000000000000000000000;
        # 30 enable = 1;
        # 30 Addr = 32'b00000000000000000000000000000001;
        # 30 Addr = 32'b00000000000000000000000000000010;
    end
    always
        #10 clk = ~clk;
endmodule
