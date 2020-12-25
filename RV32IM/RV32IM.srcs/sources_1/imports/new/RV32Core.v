`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 25.10.2020 13:23:36
// Design Name:
// Module Name: five_stages_combined
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



module RV32Core #(parameter enable = 1'b1,
                  parameter XLEN = 32)
                 (input clk,
                  input ALU_Reset,
                  output [XLEN-1:0]ALU_result);

wire [4:0]current_stage;
wire [XLEN-1:0]Instr,ext_im, data_src1,data_src2_R,data_src2,mem_read_data;
wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] src1,src2,dest,mem_read_extended,mem_write_extended;
wire [31:0] imm;
wire [1:0] alu_op;
wire mem_read,mem_write,mem_to_reg,reg_write;
wire zero_flag,alu_src;
wire [XLEN-1:0] IF_buf;
wire [XLEN-1:0] data;
wire wr_enable;
reg [XLEN-1:0] PC, PC_addr;
wire jump, branch;

// Stall signals
wire [5:0] stall;
wire stallreq_IF;
wire stallreq_ID;
wire stallreq_EX;
wire stallreq_MEM;


initial
begin
    PC <= 0;
end


// Progam Counter 
wire [31:0]IF_PC;
wire IF_PC_ready;
reg_PC reg_PC0(
    // Inputs
    .clk(clk), .rst(rst), .stall(stall), .br(branch), .br_addr(PC_addr), 
    // Outputs
    .pc_o(IF_PC), .PC_ready_o(IF_PC_ready));


//Instruction fetch from ROM
//output - Instruction to be decoded
Stage_IF fetch(
                // Inputs
                .PC(IF_PC), .PC_ready(IF_PC_ready), .branch(branch), .rst(rst), .select(current_stage[0]),
                // Outputs
                .Instr(Instr), .stallreq(stallreq_IF) );

// Pipeline register between IF --------- ID

reg_IF_ID reg_IF_ID0(.clk(clk), .rst(rst));

//Instruction decode stage.
//Outputs - opcode, address of source register 1,2 , destination register,
//          immediate value (in case of I type instruction)
Stage_ID decode(.IR(IF_buf),.clk(clk),.DecoderEnable(current_stage[1]),
.opcode(opcode),.funct3(funct3),.funct7(funct7),.src1(src1),
.src2(src2),.dest(dest),.imm(imm));

//Control unit generates control signals based on opcode
//output - control signals, current_stage(enables IF,ID,EX,MEM,WB stages)
ControlUnit control_unit(.clk(clk),.opcode(opcode),.alu_op(alu_op),.mem_read(mem_read), .branch(branch), .jump(hump),
.mem_write(mem_write),.alu_src(alu_src),.mem_to_reg(mem_to_reg),.reg_write(reg_write),.current_stage(current_stage));
Registers_Module Registers(.clk(clk),.src1(src1), .src2(src2), .dest(dest),
.we(wr_enable), .re(enable),.re1(enable), .re2(enable),
.rs1(data_src1), .rs2(data_src2_R),.rd(data));

Mux SRC2_Select(.d0(data_src2_R),.d1(imm),.select(alu_src),.d_out(data_src2));

Stage_EX execute(.ALUOp(alu_op),.funct7(funct7),.funct3(funct3),.rs1(data_src1), .rs2(data_src2),
.clk(clk), .ALU_Reset(ALU_Reset), .select(current_stage[2]),.result(ALU_result),
.zero_flag(zero_flag));


Stage_MEM access_dm(.clk(clk), .mem_write(mem_write),.mem_read(mem_read),.select(current_stage[3]),
.Addr(ALU_result),.funct3(funct3),
.data_i(data_src2_R),.data_o(mem_read_data));

//write back stage, writes output to destination register
//output - None
assign data = (jump)? PC + 4:
(mem_to_reg == 1'b1)? mem_read_data : ALU_result;
assign wr_enable = current_stage[4] & reg_write;

// STAGE_WB


always @(negedge current_stage[4])
begin
    PC_addr = PC + {32{imm, 1'b0}};
    PC      = (jump || (branch & ALU_result[0]))? PC_addr : (PC + 4);
end
///*/
endmodule
