`timescale 1ns / 1ps

`define FUNCT3_LB   3'b000
`define FUNCT3_LH   3'b001
`define FUNCT3_LW   3'b010
`define FUNCT3_LBU  3'b100
`define FUNCT3_LHU  3'b101

`define FUNCT3_SB   3'b000
`define FUNCT3_SH   3'b001
`define FUNCT3_SW   3'b010

`define XLEN 32

module Stage_MEM_TB;

//Input
reg clk =0;
reg select, mem_read, mem_write;
reg [`XLEN-1:0] Addr, data_i;
reg [2:0]funct3;

// Output
wire [`XLEN-1:0] data_o;

// Pass
reg pass;

//Module Instantiation
Stage_MEM Mem(.Addr(Addr),.data_i(data_i),.funct3(funct3),
              .mem_read(mem_read),.mem_write(mem_write),.data_o(data_o),.select(select),.clk(clk));

//Clock generation
always #10 clk = ~clk;

//Sample Values
reg [`XLEN-1:0] I_byte = 32'hab;   
reg [`XLEN-1:0] I_HalfWord = 32'habcd;
reg [`XLEN-1:0] I_Word = 32'habcdefab;

reg [`XLEN-1:0] Addr_B = 32'b1000;
reg [`XLEN-1:0] Addr_HW = 32'b11000;
reg [`XLEN-1:0] Addr_W = 32'b111000;

initial 
begin

//Write Mode
select = 1'b1;
mem_write = 1'b1;
mem_read = 1'b0;
// Write Byte 
#20
    data_i = I_byte; 
    Addr = Addr_B;    // --> chip : Addr[1:0] = 0(00) , Address : Addr[31:2] = 2(10)
    funct3 = `FUNCT3_SB;
#20
    data_i = I_byte+1; 
    Addr = Addr_B+1;    // --> chip : Addr[1:0] = 1(01) , Address : Addr[31:2] = 2(10)
    funct3 = `FUNCT3_SB;
#20
    data_i = I_byte+2; 
    Addr = Addr_B+2;    // --> chip : Addr[1:0] = 2(10) , Address : Addr[31:2] = 2(10)
    funct3 = `FUNCT3_SB;
#20
    data_i = I_byte+3; 
    Addr = Addr_B+3;    // --> chip : Addr[1:0] = 3(11) , Address : Addr[31:2] = 2(10)
    funct3 = `FUNCT3_SB;

// Write HalfWord
#20
    data_i = I_HalfWord;
    Addr = Addr_HW;   // --> chips : Addr[1:0] = 0&1 (00)  , Address : Addr[31:2] = 6(110)
    funct3 = `FUNCT3_SH;
#20
    data_i = I_HalfWord+1;
    Addr = Addr_HW+2;   // --> chips : Addr[1:0] = 2&3 (10)  , Address : Addr[31:2] = 6(110)
    funct3 = `FUNCT3_SH;

// Write Word
#20
    data_i = I_Word;
    Addr = Addr_W;     // --> chips : Addr[1:0] = 0&1&2&3 (00)  , Address : Addr[31:2] = 14(1110)
    funct3 = `FUNCT3_SW;

//Read Mode
#20
    select = 1'b1;
    mem_write = 1'b0;
    mem_read = 1'b1;

#20
    Addr = Addr_B;    
    funct3 = `FUNCT3_LBU;
#20
    pass = (I_byte == data_o)? 1:0;
    if(pass)
        $display("BYTE Test Passed\n");
    else 
        $display("BYTE Test Failed!!!\n");

#20
    Addr = Addr_B+1;    
    funct3 = `FUNCT3_LBU;
#20
    pass = ((I_byte+1) == data_o)? 1:0;
    if(pass)
        $display("BYTE Test Passed\n");
    else 
        $display("BYTE Test Failed!!!\n");
    
#20
    Addr = Addr_B+2;    
    funct3 = `FUNCT3_LBU;
#20
    pass = ((I_byte+2) == data_o)? 1:0;
    if(pass)
        $display("BYTE Test Passed\n");
    else 
        $display("BYTE Test Failed!!!\n");
        
#20
    Addr = Addr_B+3;    
    funct3 = `FUNCT3_LBU;
#20
    pass = ((I_byte+3) == data_o)? 1:0;
    if(pass)
        $display("BYTE Test Passed\n");
    else 
        $display("BYTE Test Failed!!!\n");
        
#20
    Addr = Addr_HW;    
    funct3 = `FUNCT3_LHU;
#20
    pass = (I_HalfWord == data_o)? 1:0;
    if(pass)
        $display("HALF_WORD Test Passed\n");
    else 
        $display("HALF_WORD Test Failed!!!\n");
        
#20
    Addr = Addr_HW+2;    
    funct3 = `FUNCT3_LHU;
#20
    pass = ((I_HalfWord+1) == data_o)? 1:0;
    if(pass)
        $display("HALF_WORD Test Passed\n");
    else 
        $display("HALF_WORD Test Failed!!!\n");

#20
    Addr = Addr_W;    
    funct3 = `FUNCT3_LW;
#20
    pass = (I_Word == data_o)? 1:0;
    if(pass)
        $display("WORD Test Passed\n");
    else 
        $display("BYTE Test Failed!!!\n");



end


//pass = 


endmodule
