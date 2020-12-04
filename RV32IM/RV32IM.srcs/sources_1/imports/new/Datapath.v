`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2020 01:22:17
// Design Name: 
// Module Name: Datapath
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

/*`include "ROM_Module.v"
`include "Registers_Module.v"
`include "RAM_Module.v"
`include "ALU_Module.v"
`include "ALU_control_unit.v"
*/
module Datapath #(parameter XLEN=32)
                
                (input clk,
                input [3:0] MemRead, MemWrite,
                input MemToReg,RegWrite, RegRead,RegRead1, RegRead2,
                input ALUSrc,
                input [1:0] ALUOp,
                output [6:0] opcode
                );
                
 reg [XLEN-1:0] PC_current;
 wire [XLEN-1:0] PC_next;
 wire [XLEN-1:0] Instr;
 
 wire [4:0] reg_write_dest;      
 wire[XLEN-1:0] reg_write_data;
 wire [4:0] reg_read_addr_1;
 wire [XLEN-1:0] reg_read_data_1;
 wire [4:0] reg_read_addr_2;
 wire [XLEN-1:0] reg_read_data_2;
 
 wire [XLEN-1:0] ext_im,read_data2;
 wire [4:0] ALU_Control;
 wire [XLEN-1:0] ALU_Out;
 wire zero_flag;
 
 wire[XLEN-1:0] mem_read_data;
 
 initial begin
 //Program Counter
 PC_current <= 32'd0;
 end
 always @(posedge clk)
 begin
 PC_current <= PC_next;
 end
 
 //Fetching Instruction by instantiating ROM_Module
 ROM_Module fetch_instr( 
                        .Addr(PC_current), .Instr(Instr), 
                        .ROM_Enable(1'b1),.clk(clk),.ROM_Rst(1'b0)
                        );
 
 assign PC_next =  PC_current + 32'd4; //Pointing to next instruction 
 //  Register file
 assign reg_read_addr_1= Instr[19:15];
 assign reg_read_addr_2= Instr[24:20];
 
 Register_Module Registers(
                          .clk(clk),
                          .src1(reg_read_addr_1), .src2(reg_read_addr_2), .dest(reg_write_dest),
                          .we(RegWrite), .re(RegRead),.re1(RegRead1), .re2(RegRead2),
                          .rs1(reg_read_data_1), .rs2(reg_read_data_2)
                          );
                         
 
 // Sign extending immediate offset 
 assign ext_im= {{20{Instr[XLEN-1]}}, Instr[31:19]};
 
 //ALU Control Unit
 ALU_Control ALU_Control_Unit( .clk(clk),
                               .ALUOp(ALUOp), .funct7(Instr[31:25]), .funct3(Instr[14:12]),
                               .ALU_control_line(ALU_Control), .ALU_control_enable(1'b1)
                              );
  //Multiplexer for choosing between ALUSrc and Immediate                     
  assign read_data2= (ALUSrc==1'b1)? ext_im : reg_read_data_2;
  
  //ALU_Module
  ALU_Module ALU(   .clk(clk),
                    .rs1(reg_read_data_1), .rs2(reg_read_data_2), .ALUOp(ALU_Control),
                    .result(ALU_Out), .ALU_Enable(1'b1), .ALU_Reset(1'b0),
                    .zero_flag(zero_flag));
   //Data Memory 
   RamMemory dm (  .Addr0(ALU_Out), .clk(clk),
                   .re(MemRead), .we(MemWrite),
                   .data_i(reg_read_data_2), .data_o(mem_read_data),.cs(1'b1));
                 
    //write back
    assign reg_write_data= (MemToReg== 1'b1)? mem_read_data : ALU_Out;
    
   //Output to control unit
    assign opcode= Instr[6:0];
                 
endmodule
