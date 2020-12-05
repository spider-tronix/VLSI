`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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
             input mem_read,
             input mem_write,
             input MMUEnable,
             output reg [3:0] cs,re,wr,
             output reg [XLEN-3:0] Addr_o  //2 bits for chip select
            );
                       
initial
begin

// Address bits 
Addr_o <= Addr_i[XLEN-1:2];
$display("%0b", funct3);

// Chip select bits
case(funct3[1:0])
2'b00: //Byte Store and Load
    begin 
    cs[3:0] = (Addr_i[1:0] == 2'b00) ? 4'b0001:
               (Addr_i[1:0] == 2'b01) ? 4'b0010:
               (Addr_i[1:0] == 2'b10) ? 4'b0100:
               (Addr_i[1:0] == 2'b11) ? 4'b1000: 4'b0000;      
    end
2'b01: //Halfword Store and Load
    begin
    cs[3:0] = (Addr_i[1:0] == 2'b00) ? 4'b0011:
               (Addr_i[1:0] == 2'b10) ? 4'b1100: 4'b0000;
    end   
2'b10: //Word Store and Load
    begin
    cs[3:0] = 4'hf;
    end
default:
    begin
    
    cs[3:0] = 4'hf;
    end

endcase

//Data Read and write bits
assign re = mem_read ? cs : 4'b0000;
assign wr = mem_write ? cs : 4'b0000;  

end
endmodule
