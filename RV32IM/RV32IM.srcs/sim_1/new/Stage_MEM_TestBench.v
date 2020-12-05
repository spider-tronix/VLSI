`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.12.2020 17:53:17
// Design Name: 
// Module Name: Stage_MEM_TestBench
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
//Defines
    `define XLEN 32
    `define WORDLENGTH 8
    // JALR
    `define FUNCT3_JALR 3'b000
    // BRANCH
    `define FUNCT3_BEQ  3'b000
    `define FUNCT3_BNE  3'b001
    `define FUNCT3_BLT  3'b100
    `define FUNCT3_BGE  3'b101
    `define FUNCT3_BLTU 3'b110
    `define FUNCT3_BGEU 3'b111
    // LOAD
    `define FUNCT3_LB   3'b000
    `define FUNCT3_LH   3'b001
    `define FUNCT3_LW   3'b010
    `define FUNCT3_LBU  3'b100
    `define FUNCT3_LHU  3'b101
    // STORE
    `define FUNCT3_SB   3'b000
    `define FUNCT3_SH   3'b001
    `define FUNCT3_SW   3'b010
    // OP-IMM
    `define FUNCT3_ADDI      3'b000
    `define FUNCT3_SLTI      3'b010
    `define FUNCT3_SLTIU     3'b011
    `define FUNCT3_XORI      3'b100
    `define FUNCT3_ORI       3'b110
    `define FUNCT3_ANDI      3'b111
    `define FUNCT3_SLLI      3'b001
    `define FUNCT3_SRLI_SRAI 3'b101
    // OP
    `define FUNCT3_ADD_SUB 3'b000
    `define FUNCT3_SLL     3'b001
    `define FUNCT3_SLT     3'b010
    `define FUNCT3_SLTU    3'b011
    `define FUNCT3_XOR     3'b100
    `define FUNCT3_SRL_SRA 3'b101
    `define FUNCT3_OR      3'b110
    `define FUNCT3_AND     3'b111
    // MISC-MEM
    `define FUNCT3_FENCE  3'b000
    `define FUNCT3_FENCEI 3'b001

module Stage_MEM_TestBench;
    //Samples
    reg [`XLEN-1:0] I_byte = 32'b10010110;
    reg [`XLEN-1:0] I_HalfWord = 32'b1111000011110000;
    reg [`XLEN-1:0] I_Word = 32'b11110000111100001111000011110000;


    //Input
    reg clk =0;
    reg select, mem_read, mem_write;
    reg [`XLEN-1:0] Addr, data_i;
    reg [2:0]funct3;
    // Output
    wire [`XLEN-1:0] data_o;
    //Clock generation
    always #10 clk = ~clk;

    wire [`XLEN-3:0] Addr_M ;
    wire [3:0] cs,re,wr;
    wire [`XLEN-1:0] data_to_mem,data_from_mem;

    //Instantiation

MMU MemControl (.funct3(funct3), .mem_read(mem_read), .mem_write(mem_write), .MMUEnable(1'b1), .cs(cs), .re(re), .wr(wr), .Addr_o(Addr_M), .Addr_i(Addr));
input_shifter DataIN (.data_in(data_i), .funct3(funct3), .Addr(Addr[1:0]), .data_out(data_to_mem));
output_shifter DataOut (.data_in(data_from_mem), .funct3(funct3), .Addr(Addr[1:0]), .data_out(data_o)); 
RamMemory Dm (.cs(cs), .re(re), .we(wr), .Addr(Addr_M), .data_i(data_to_mem), .data_o(data_from_mem));
   
   
    // Stage_MEM SM(.clk(clk), .select(select), .mem_read(mem_read), .mem_write(mem_write),
    //                 .Addr(Addr), .data_i(data_i),
    //                 .funct3(funct3),
    //                 .data_o(data_o)
    //             );
    initial begin
    // Writing to Memory 
    select = 1; mem_read = 0; mem_write = 1;
        // Byte
        funct3 = 3'b000;
        data_i  = I_byte;
        Addr = 32'b1001;
        #25
        // Half Word
        funct3 = `FUNCT3_LH;
        data_i  = I_HalfWord;
        Addr = 32'b11001;
        #25
        //  Word
        funct3 = `FUNCT3_LW;
        data_i  = I_Word;
        Addr = 32'b111001;
        #25
    // Reding from Memory 
    select = 1; mem_read = 1; mem_write = 0;
        // Byte
        Addr = 32'b1001;
        #25
        if( I_byte == data_o)
            $display("BYTE Test Passed\n");
        else 
            $display("BYTE Test Failed!!!\n");

        // Half Word
        Addr = 32'b11001;
        #25
        if( I_HalfWord == data_o)
            $display("HALF_WORD Test Passed\n");
        else 
            $display("HALF_WORD Test Failed!!!\n");
        //  Word
        Addr = 32'b111001;
        #25
        if( I_Word == data_o)
            $display("WORD Test Passed\n");
        else 
            $display("WORD Test Failed!!!\n");
        
    end
endmodule
