`timescale 1ns / 1ps
module RAM_Module #(parameter WORDLENGTH = 8,
                    parameter XLEN = 32,
                    parameter Size = 2048)
                    
                   (input [XLEN-3:0] Addr,
                    input [WORDLENGTH-1:0] data_i,
                    input re,we,cs,
                    // clk,
                    output reg [WORDLENGTH-1:0] data_o);
                     
reg [WORDLENGTH-1:0] RAM_mem[0:Size-1];

always @(*)
begin
    if(cs)
        begin
            if(re)
                data_o <= RAM_mem[Addr];               
            else
            if(we)
                RAM_mem[Addr] <= data_i;
        end
end
endmodule
