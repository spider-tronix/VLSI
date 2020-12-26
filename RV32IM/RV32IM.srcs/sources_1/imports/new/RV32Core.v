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

wire take_branch;
assign take_branch = (branch & ALU_result[0]);

initial
begin
    PC <= 0;
end


// Progam Counter 
wire [31:0]IF_PC;
wire IF_PC_ready;
reg_PC reg_PC0(
    // Inputs
    .clk(clk), .rst(rst), .stall(stall), .br(take_branch), .br_addr(PC_addr), 
    // Outputs
    .pc_o(IF_PC), .PC_ready_o(IF_PC_ready));


// -------------------------- STAGE_IF -------------------------------
Stage_IF fetch(
                // Inputs
                .PC(IF_PC), .PC_ready(IF_PC_ready), .branch(take_branch), .rst(rst), .select(current_stage[0]),
                // Outputs
                .Instr(Instr), .stallreq(stallreq_IF) );
// -------------------------- **STAGE_IF** -------------------------------

// Pipeline register between IF --------- ID
wire [XLEN-1:0] Instr_IF_ID_reg_to_ID;
reg_IF_ID reg_IF_ID0(
    // Inputs 
    .clk(clk), .rst(rst),
    .branch(take_branch),
    .stall(stall),
    .IF_instr(Instr),
    .ID_instr(Instr_IF_ID_reg_to_ID)
    );

// -------------------------- STAGE_ID -------------------------------

Stage_ID decode(
    // Inputs
    .IR(Instr_IF_ID_reg_to_ID),
    // .clk(clk),
    .DecoderEnable(current_stage[1]),
    // Outputs
    .opcode(opcode),
    .funct3(funct3),.funct7(funct7),
    .src1(src1),.src2(src2),.dest(dest),
    .imm(imm));

//Control unit generates control signals based on opcode
//output - control signals, current_stage(enables IF,ID,EX,MEM,WB stages)
ControlUnit control_unit(
    // Inputs
    .clk(clk),
    .opcode(opcode),
    .stallreq_MEM(stallreq_MEM),
    .stallreq_EX(stallreq_EX),
    .stallreq_ID(stallreq_ID),
    .stallreq_IF(stallreq_IF),
    // Outputs
    .alu_op(alu_op),.mem_read(mem_read), .branch(branch), .jump(hump),
    .mem_write(mem_write),.alu_src(alu_src),.mem_to_reg(mem_to_reg),.reg_write(reg_write),.current_stage(current_stage));
wire [4:0] WB_dest;
Registers_Module Registers(
    // Inputs
    // .clk(clk),
    .src1(src1), .src2(src2), .dest(WB_dest),
    .we(wr_enable), .re(enable),.re1(enable), .re2(enable),
    .rd(data),
    // Outputs
    .rs1(data_src1), .rs2(data_src2_R));

Mux SRC2_Select(.d0(data_src2_R),.d1(imm),.select(alu_src),.d_out(data_src2));
// -------------------------- **STAGE_ID** -------------------------------

wire [2:0] EX_funct3;
wire [6:0] EX_funct7;
wire [4:0] EX_data_src1,
EX_data_src2,
EX_dest;     // To be linked in the WB stage to "WB_dest"
wire [31:0] EX_imm;
wire[1:0] EX_alu_op;
wire EX_mem_read,
EX_mem_write,
EX_mem_to_reg,
EX_reg_write,
EX_branch,
EX_jump;
wire [XLEN-1:0] EX_data_src2_R;

// Pipeline register between ID --------- EX
reg_ID_EX reg_ID_EX0 (
    // Inputs from ID
    .rst(rst), .clk(clk), .stall(stall),
    .ID_funct3(funct3), .ID_funct7(funct7),
    .ID_data_src2_R(data_src2_R),
    .ID_src1(data_src1), .ID_src2(data_src2), .ID_dest(dest), .ID_imm(imm),
    // Inputs from Control Unit
    .ID_alu_op(alu_op), .ID_mem_read(mem_read), .ID_mem_write(mem_write),
    .ID_alu_src(alu_src), .ID_mem_to_reg(mem_to_reg), .ID_reg_write(ID_reg_write), 
    .ID_branch(branch), .ID_jump(jump), .ID_data_src2_R(data_src2_R),

    // Outputs
    .EX_funct3(EX_funct3), .EX_funct7(EX_funct7), .EX_src1(EX_data_src1), .EX_src2(EX_data_src2),
    .EX_dest(EX_dest), .EX_imm(EX_imm), .EX_alu_op(EX_alu_op), .EX_mem_read(EX_mem_read),
    .EX_mem_write(EX_mem_write), .EX_mem_to_reg(EX_mem_to_reg),
    .EX_reg_write(EX_reg_write), .EX_branch(EX_branch), .EX_jump(EX_jump),
    .EX_data_src2_R(EX_data_src2_R)
); 
// -------------------------- STAGE_EX -------------------------------
Stage_EX execute(
    // Input
    .ALUOp(EX_alu_op),.funct7(EX_funct7),.funct3(EX_funct3),
    .rs1(EX_data_src1), .rs2(EX_data_src2),
    .ALU_Reset(rst), .select(current_stage[2]),
    // Output
    .result(ALU_result),.zero_flag(zero_flag)
);
// -------------------------- **STAGE_EX** -------------------------------
// Pipeline register between EX --------- MEM
reg_EX_MEM reg_EX_MEM0(
    // Input
    .clk(clk), .rst(rst), .stall(stall),
    .EX_Addr(ALU_result), .EX_data_i(EX_data_src2_R), .EX_funct3(EX_funct3), 
    .EX_mem_read(EX_mem_read), .EX_mem_write(EX_mem_write),

    // Outputs
    .MEM_Addr(MEM_ALU_result), .MEM_data_i(MEM_data_src2_R), .MEM_funct3(MEM_funct3), 
    .MEM_mem_read(MEM_mem_read), .MEM_mem_write(MEM_mem_write)
);
// -------------------------- STAGE_MEM -------------------------------
Stage_MEM access_dm(.clk(clk), .mem_write(mem_write),.mem_read(mem_read),.select(current_stage[3]),
.Addr(MEM_ALU_result),.funct3(MEM_funct3),
.data_i(MEM_data_src2_R),.data_o(mem_read_data));

//write back stage, writes output to destination register
//output - None
assign data = (jump)? PC + 4:
(mem_to_reg == 1'b1)? mem_read_data : ALU_result;
assign wr_enable = current_stage[4] & reg_write;

// STAGE_WB


always @(negedge current_stage[4])
begin
    PC_addr = PC + {32{imm, 1'b0}};
    PC      = (jump || take_branch)? PC_addr : (PC + 4);
end
///*/
endmodule
