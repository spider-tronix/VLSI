`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.12.2020 18:11:06
// Design Name: 
// Module Name: stage_mem_tb
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


module stage_mem_tb;
parameter XLEN=32;
parameter WORDLENGTH = 8;
//inputs
reg select, mem_read, mem_write;
reg [XLEN-1:0] Addr, data_i;
reg [2:0] funct3;
//outputs
wire [XLEN-1:0] data_o;
wire stallreq;
Stage_MEM
 uut (

 .select(select), .
Addr(Addr),
 .data_i(data_i),
 .funct3(funct3),
                  .mem_read(mem_read),
 .mem_write(mem_write),
 .data_o(data_o),
 .stallreq(stallreq));

initial begin
select = 1;
#10
funct3 = 3'b010;//halfword store 
data_i <= 32'b11111111111111111111111111111111;
Addr = 32'b1100;
mem_write = 1;
mem_read = 0;

#20
funct3 = 3'b010;//halfword store 
data_i = 32'b11111111111111111111111111110000;
Addr = 32'b1010;
mem_write = 1;
mem_read=0;

#30
funct3 = 3'b000; //load byte at address 32'b1100
Addr = 32'b1100;
mem_write = 0;
mem_read = 1;

end
endmodule
