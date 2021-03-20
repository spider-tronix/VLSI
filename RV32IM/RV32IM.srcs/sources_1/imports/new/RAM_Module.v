`timescale 1ns / 1ps
module RAM_Module_0 #(parameter WORDLENGTH = 8,
                    parameter XLEN = 32,
                    parameter Size = 256)
                    
                   (input [XLEN-3:0] Addr,
                    input [WORDLENGTH-1:0] data_i,
                    input re,we,cs,
                    clk,
                    output reg [WORDLENGTH-1:0] data_o);
                     
 reg [WORDLENGTH-1:0] RAM_mem[0:Size-1];
initial begin 
    $readmemh("Sample/RV32IF/Add/dmem0.txt", RAM_mem);
    $display("RAM0 Done Reading!!!!!!");
end 
always @(negedge clk)
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

module RAM_Module_1 #(parameter WORDLENGTH = 8,
                    parameter XLEN = 32,
                    parameter Size = 256)
                    
                   (input [XLEN-3:0] Addr,
                    input [WORDLENGTH-1:0] data_i,
                    input re,we,cs,
                    clk,
                    output reg [WORDLENGTH-1:0] data_o);
                     
 reg [WORDLENGTH-1:0] RAM_mem[0:Size-1];
initial begin 
    $readmemh("Sample/RV32IF/Add/dmem1.txt", RAM_mem);
    $display("RAM1 Done Reading!!!!!!");
end 
always @(negedge clk)
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

module RAM_Module_2 #(parameter WORDLENGTH = 8,
                    parameter XLEN = 32,
                    parameter Size = 256)
                    
                   (input [XLEN-3:0] Addr,
                    input [WORDLENGTH-1:0] data_i,
                    input re,we,cs,
                    clk,
                    output reg [WORDLENGTH-1:0] data_o);
                     
 reg [WORDLENGTH-1:0] RAM_mem[0:Size-1];
initial begin 
    $readmemh("Sample/RV32IF/Add/dmem2.txt", RAM_mem);
    $display("RAM2 Done Reading!!!!!!");
end 
always @(negedge clk)
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

module RAM_Module_3 #(parameter WORDLENGTH = 8,
                    parameter XLEN = 32,
                    parameter Size = 256)
                    
                   (input [XLEN-3:0] Addr,
                    input [WORDLENGTH-1:0] data_i,
                    input re,we,cs,
                    clk,
                    output reg [WORDLENGTH-1:0] data_o);
                     
reg [WORDLENGTH-1:0] RAM_mem[0:Size-1];
initial begin 
    $readmemh("Sample/RV32IF/Add/dmem3.txt", RAM_mem);
    $display("RAM3 Done Reading!!!!!!");
end 
always @(negedge clk)
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
