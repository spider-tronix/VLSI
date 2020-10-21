`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2020 06:24:00 PM
// Design Name: 
// Module Name: MMU
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


module MMU #(parameter XLEN = 32)
            (input [XLEN-1:0] Addr_i,
             input [2:0]funct3,
             output reg [3:0]cs,
             input MMUEnable,
             output reg [XLEN-3:0]Addr_o[3:0]  //2 bits for chip select
            );
            
initial 
begin
case(funct3[1:0])
00: //Byte Store and Load
    begin 
    cs[Addr_i[1:0]] <= 1 ;
    Addr_o[Addr_i[1:0]] <= Addr_i[XLEN-1:2];
    end
01: //Halfword Store and Load
    begin
    cs[Addr_i[1:0]] <= 1 ;
    cs[(Addr_i[1:0]+1)%4] <= 1 ;
    Addr_o[Addr_i[1:0]] <= Addr_i[XLEN-1:2];
    Addr_o[(Addr_i[1:0]+1)%4] <= (Addr_i[1:0]==2'b11) ? (Addr_i[XLEN-1:2]+1) : (Addr_i[XLEN-1:2]);
    end   
10: //Word Store and Load
    begin
    cs[3:0] <= 4'hf;
    Addr_o[Addr_i[1:0]] <= Addr_i[XLEN-1:0]/4;
    Addr_o[(Addr_i[1:0]+1)%4] <= (Addr_i[XLEN-1:0]+1)/4;
    Addr_o[(Addr_i[1:0]+2)%4] <= (Addr_i[XLEN-1:0]+2)/4;
    Addr_o[(Addr_i[1:0]+3)%4] <= (Addr_i[XLEN-1:0]+3)/4;
    end
endcase
end
endmodule
