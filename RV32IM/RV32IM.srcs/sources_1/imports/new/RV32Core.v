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



module RV32Core #(parameter enable = 1'b1,parameter XLEN = 32)
                 (input clk,
                  input ALU_Reset,
                  output [XLEN-1:0]ALU_result);
    
    // Stall signals
    wire [5:0] stall;
    wire stallreq_IF;
    wire stallreq_ID;
    wire stallreq_EX;
    wire stallreq_MEM;
    
    wire take_branch;
    // Progam Counter
    wire [31:0]IF_PC;
    wire IF_PC_ready;
    wire [XLEN-1:0] Instr;
    // Reg IF-ID
    wire [XLEN-1:0] Instr_IF_ID_reg_to_ID;
    wire [31:0]ID_PC;
    // STAGE_ID
    wire [XLEN-1:0] data_src1,data_src2;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] src1,src2,dest;
    wire [31:0] imm;
    wire [1:0] alu_op;
    wire mem_read,mem_write,mem_to_reg,reg_write;
    wire zero_flag,alu_src;
    wire jump, branch;
    wire [XLEN - 1:0] ID_branch_addr, ID_link_addr;
    wire [XLEN - 1:0] ID_data1, ID_data2, ID_data_R;
    wire ID_load, EX_load;
    // Registers Module 
    // Reg ID-EX
    wire [2:0] EX_funct3;
    wire [6:0] EX_funct7;
    wire [XLEN - 1:0] EX_data_src1, EX_data_src2;
    wire [4:0] EX_dest;     // "EX_dest" linked in the WB stage to "WB_dest"
    wire [31:0] EX_imm;
    wire[1:0] EX_alu_op;
    wire EX_mem_read;
    wire EX_mem_write;
    wire EX_mem_to_reg;
    wire EX_reg_write;
    wire EX_branch;
    wire EX_jump;
    wire [XLEN-1:0] EX_data_src2_R;
    wire [XLEN - 1:0] EX_branch_addr, EX_link_addr;
    // Reg EX-MEM
    wire [XLEN-1:0] MEM_ALU_result, MEM_data_src2_R, mem_read_data, MEM_data;
    wire [2:0] MEM_funct3;
    wire [4:0] MEM_dest;
    wire MEM_mem_read, MEM_mem_write, MEM_reg_write, MEM_mem_to_reg, MEM_jump;

    // Others
    wire [4:0] WB_dest;
    wire [XLEN-1:0] WB_data;
    wire WB_wr_enable;
    wire [4:0]current_stage;

    reg_PC reg_PC0(
        // Inputs
        .clk(clk), .rst(rst), .stall(stall), .br(take_branch), .br_addr(EX_branch_addr),
        // Outputs
        .pc_o(IF_PC), .PC_ready_o(IF_PC_ready)
    );

        // -------------------------- STAGE_IF -------------------------------
    Stage_IF fetch(
        // Inputs
        .PC(IF_PC), .PC_ready(IF_PC_ready), .branch(take_branch), .rst(rst), .select(current_stage[0]),
        // Outputs
        .Instr(Instr), .stallreq(stallreq_IF)
    );
        // -------------------------- **STAGE_IF** -------------------------------
        
        // Pipeline register between IF --------- ID
    reg_IF_ID reg_IF_ID0(
        // Inputs
        .clk(clk), .rst(rst),
        .branch(take_branch),
        .stall(stall),
        .IF_instr(Instr),
        .IF_PC(IF_PC),
        .ID_PC(ID_PC),
        .ID_instr(Instr_IF_ID_reg_to_ID)
    );
        
        // -------------------------- STAGE_ID -------------------------------
    
    Stage_ID decode(
        // Inputs
        .IR(Instr_IF_ID_reg_to_ID),
        .regdata1(data_src1), .regdata2(data_src2),
        // .clk(clk),
        .rst(rst),
        .DecoderEnable(current_stage[1]),
        // Data Forwarding
            // MEM
            .MEM_reg_write(MEM_reg_write),
            .MEM_data(MEM_data),
            .MEM_dest(MEM_dest),
            // EX
            .EX_reg_write(EX_reg_write),
            .EX_data(ALU_result),
            .EX_dest(EX_dest),
            .EX_load(EX_load),
        // Outputs
        .opcode(opcode),
        .funct3(funct3),.funct7(funct7),
        .src1(src1),.src2(src2),.dest(dest),
        .imm(imm),
        .stallreq(stallreq_ID),
        .data1(ID_data1), .data2(ID_data2),
        .data_R(ID_data_R)
    );
        
    ControlUnit control_unit(
        // Inputs
        // .clk(clk),
        .opcode(opcode),
        .stallreq_MEM(stallreq_MEM),
        .stallreq_EX(stallreq_EX),
        .stallreq_ID(stallreq_ID),
        .stallreq_IF(stallreq_IF),
        .PC(ID_PC),
        .rst(rst),
        .IR(Instr_IF_ID_reg_to_ID),
        .data_src1(data_src1),  // For calculating branch address
        // Outputs
        .alu_op(alu_op),.mem_read(mem_read), .branch(branch), .jump(jump),
        .mem_write(mem_write),.alu_src(alu_src),.mem_to_reg(mem_to_reg),.reg_write(reg_write),.current_stage(current_stage),
        .branch_addr(ID_branch_addr), .link_addr(ID_link_addr), .load(ID_load),
        .stall(stall)
    );
    Registers_Module Registers(
        // Inputs
        // .clk(clk),
        .src1(src1), .src2(src2), .dest(WB_dest),
        .we(WB_wr_enable), .re(enable),.re1(enable), .re2(enable),
        .rd(WB_data),
        // Outputs
        .rs1(data_src1), .rs2(data_src2)
    );        
        // -------------------------- **STAGE_ID** -------------------------------
        
        // Pipeline register between ID --------- EX
    reg_ID_EX reg_ID_EX0 (
        // Inputs from ID
        .rst(rst), .clk(clk), .stall(stall),
        .ID_funct3(funct3), .ID_funct7(funct7),
        .ID_data_src2_R(ID_data_R),
        .ID_src1(ID_data1), .ID_src2(ID_data2), .ID_dest(dest), .ID_imm(imm),
        // Inputs from Control Unit
        .ID_alu_op(alu_op), .ID_mem_read(mem_read), .ID_mem_write(mem_write),
        .ID_alu_src(alu_src), .ID_mem_to_reg(mem_to_reg), .ID_reg_write(reg_write),
        .ID_branch(branch), .ID_jump(jump), 
        .ID_link_addr(ID_link_addr), .ID_branch_addr(ID_branch_addr), .ID_load(ID_load),
        // Outputs
        .EX_funct3(EX_funct3), .EX_funct7(EX_funct7), .EX_src1(EX_data_src1), .EX_src2(EX_data_src2),
        .EX_dest(EX_dest), .EX_imm(EX_imm), .EX_alu_op(EX_alu_op), .EX_mem_read(EX_mem_read),
        .EX_mem_write(EX_mem_write), .EX_mem_to_reg(EX_mem_to_reg),
        .EX_reg_write(EX_reg_write), .EX_branch(EX_branch), .EX_jump(EX_jump),
        .EX_data_src2_R(EX_data_src2_R),
        .EX_link_addr(EX_link_addr), .EX_branch_addr(EX_branch_addr), .EX_load(EX_load)
    );
        // -------------------------- STAGE_EX -------------------------------
    assign take_branch = (EX_branch & ALU_result[0]);
    Stage_EX execute(
        // Inputs
        .ALUOp(EX_alu_op),.funct7(EX_funct7),.funct3(EX_funct3),
        .rs1(EX_data_src1), .rs2(EX_data_src2),
        .ALU_Reset(rst), .select(current_stage[2]),  // TODO Add jump and link addr
        .link_addr(EX_link_addr), .jump(EX_jump),
        // Outputs
        .result(ALU_result),.zero_flag(zero_flag), .stallreq(stallreq_EX)
    );
        // -------------------------- **STAGE_EX** -------------------------------
    
        // Pipeline register between EX --------- MEM
    reg_EX_MEM reg_EX_MEM0(
        // Inputs
        .clk(clk), .rst(rst), .stall(stall), .EX_dest(EX_dest),
        .EX_Addr(ALU_result), .EX_data_i(EX_data_src2_R), .EX_funct3(EX_funct3),
        .EX_mem_read(EX_mem_read), .EX_mem_write(EX_mem_write),
        .EX_mem_to_reg(EX_mem_to_reg), .EX_jump(EX_jump), .EX_reg_write(EX_reg_write),
        
        // Outputs
        .MEM_Addr(MEM_ALU_result), .MEM_data_i(MEM_data_src2_R), .MEM_funct3(MEM_funct3),
        .MEM_mem_read(MEM_mem_read), .MEM_mem_write(MEM_mem_write),
        .MEM_dest(MEM_dest), .MEM_mem_to_reg(MEM_mem_to_reg),
        .MEM_jump(MEM_jump), .MEM_reg_write(MEM_reg_write)
    );
        // -------------------------- STAGE_MEM -------------------------------
    Stage_MEM access_dm(
        // Inputs
        .mem_write(MEM_mem_write),.mem_read(MEM_mem_read),.select(current_stage[3]),
        .Addr(MEM_ALU_result),.funct3(MEM_funct3),
        .data_i(MEM_data_src2_R),
        
        // Output
        .data_o(mem_read_data), .stallreq(stallreq_MEM)
    );
    assign MEM_data = (MEM_mem_to_reg)?mem_read_data:MEM_ALU_result;
        // -------------------------- **STAGE_MEM** -------------------------------
        
        // Pipeline register between MEM --------- WB
    reg_MEM_WB reg_MEM_WB0(
        // Input
        .clk(clk), .rst(rst), .stall(stall),
        .MEM_data(MEM_data), .MEM_wr_enable(MEM_reg_write), .MEM_register_dest(MEM_dest),
        
        // Output
        .WB_data(WB_data), .WB_dest(WB_dest), .WB_wr_enable(WB_wr_enable)
        
    );
    //write back stage, writes output to destination register
   
endmodule
