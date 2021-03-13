`ifndef DEFINES_V
`define DEFINES_V

// ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  = Stage enable ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  == 
`define STAGE_IF    5'b00001
`define STAGE_ID    5'b00010
`define STAGE_EX    5'b00100
`define STAGE_MEM   5'b01000
`define STAGE_WB    5'b10000

// 'define OPCODE_WIDTH 7
// ==  ==  ==  ==  ==  ==  ==  ==  == Instruction opcode in RISC-V ==  ==  ==  ==  ==  ==  ==  ==  == 
`define OP_LUI      7'b0110111
`define OP_AUIPC    7'b0010111
`define OP_JAL      7'b1101111
`define OP_JALR     7'b1100111
`define OP_BRANCH   7'b1100011
`define OP_LOAD     7'b0000011  // I-Type
`define OP_STORE    7'b0100011  // S-Type
`define OP_OP_IMM   7'b0010011  // I-Type
`define OP_OP       7'b0110011  // R-Type
`define OP_MISC_MEM 7'b0001111
// Floating OPCodes
`define OP_FLW      7'b0000111
`define OP_FSW      7'b0100111
`define OP_FMADD_S  7'b1000011
`define OP_FMSUB_S  7'b1000111
`define OP_FNMSUB_S 7'b1001011
`define OP_FNMADD_S 7'b1001111
`define OP_F_OP     7'b1010011

// ==  ==  ==  ==  ==  ==  ==  ==  == Instruction funct3 in RISC-V ==  ==  ==  ==  ==  ==  ==  ==  == 
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

// Floating Point
`define FUNCT3_FSGNJ_S  3'b000
`define FUNCT3_FSGNJN_S 3'b001
`define FUNCT3_FSGNJX_S 3'b010
`define FUNCT3_FMIN_S   3'b000
`define FUNCT3_FMAX_S   3'b001

`define FUNCT3_FMV_X_W  3'b000
`define FUNCT3_FEQ_S    3'b010
`define FUNCT3_FLT_S    3'b001
`define FUNCT3_FLE_S    3'b000
`define FUNCT3_FCLASS_S 3'b001

// ==  ==  ==  ==  ==  ==  ==  ==  == Instruction funct7 in RISC-V ==  ==  ==  ==  ==  ==  ==  ==  == 
`define FUNCT7_SLLI 7'b0000000
// SRLI_SRAI
`define FUNCT7_SRLI 7'b0000000
`define FUNCT7_SRAI 7'b0100000
// ADD_SUB
`define FUNCT7_ADD  7'b0000000
`define FUNCT7_SUB  7'b0100000
`define FUNCT7_SLL  7'b0000000
`define FUNCT7_SLT  7'b0000000
`define FUNCT7_SLTU 7'b0000000
`define FUNCT7_XOR  7'b0000000
// SRL_SRA
`define FUNCT7_SRL 7'b0000000
`define FUNCT7_SRA 7'b0100000
`define FUNCT7_OR  7'b0000000
`define FUNCT7_AND 7'b0000000

// Floating Point
`define FUNCT7_FADD_S    7'b0000000
`define FUNCT7_FSUB_S    7'b0000100
`define FUNCT7_FMUL_S    7'b0001000
`define FUNCT7_FDIV_S    7'b0001100
`define FUNCT7_FSQRT_S   7'b0101100
`define FUNCT7_FSGNJ_S   7'b0010000
`define FUNCT7_FSGNJN_S  7'b0010000
`define FUNCT7_FSGNJX_S  7'b0010000
`define FUNCT7_FMIN_S    7'b0010100
`define FUNCT7_FMAX_S    7'b0010100
`define FUNCT7_FCVT_W_S  7'b1100000
`define FUNCT7_FCVT_WU_S 7'b1100000
`define FUNCT7_FMV_X_W   7'b1110000
`define FUNCT7_FEQ_S     7'b1010000
`define FUNCT7_FLT_S     7'b1010000
`define FUNCT7_FLE_S     7'b1010000
`define FUNCT7_FCLASS_S  7'b1110000
`define FUNCT7_FCVT_S_W  7'b1101000
`define FUNCT7_FCVT_S_WU 7'b1101000
`define FUNCT7_FMV_W_X   7'b1111000
// ==  ==  ==  ==  ==  ==  ==  ==  == Rounding Mode ==  ==  ==  ==  ==  ==  ==  ==  == 
`define RM_RNE 3'b000
`define RM_RTZ 3'b001
`define RM_RDN 3'b010
`define RM_RUP 3'b011
`define RM_RMM 3'b100
`define RM_DYN 3'b111

// ==  ==  ==  ==  ==  ==  ==  ==  == AluSel ==  ==  ==  ==  ==  ==  ==  ==  == 
`define EXE_RES_LOGIC       3'b001
`define EXE_RES_SHIFT       3'b010
`define EXE_RES_MOVE        3'b011
`define EXE_RES_NOP         3'b000
`define EXE_RES_ARITH       3'b100
`define EXE_RES_MUL         3'b101
`define EXE_RES_JUMP_BRANCH 3'b110
`define EXE_RES_LOAD_STORE  3'b111

// ==  ==  ==  ==  ==  ==  ==  ==  == Alu Control Line ==  ==  ==  ==  ==  ==  ==  ==  == 

`define EXE_NOP_OP 0
`define EXE_AND_OP 1
`define EXE_OR_OP  2
`define EXE_XOR_OP 3

`define EXE_SLL_OP 5
`define EXE_SRL_OP 6
`define EXE_SRA_OP 7

`define EXE_ADD_OP  8
`define EXE_SLT_OP  9
`define EXE_SLTU_OP 10
`define EXE_SUB_OP  11

`define EXE_JAL_OP  12
`define EXE_JALR_OP 13
`define EXE_BEQ_OP  14
`define EXE_BNE_OP  15
`define EXE_BLT_OP  16
`define EXE_BGE_OP  17
`define EXE_BLTU_OP 18
`define EXE_BGEU_OP 19

`define EXE_LB_OP  20
`define EXE_LH_OP  21
`define EXE_LW_OP  22
`define EXE_LBU_OP 23
`define EXE_LHU_OP 24
`define EXE_SB_OP  25
`define EXE_SH_OP  26
`define EXE_SW_OP  27

// ==  ==  ==  ==  ==  ==  ==  ==  == Alu Control Line ==  ==  ==  ==  ==  ==  ==  ==  == 
`define FPU_NOP 0
`define FPU_FMADD_S 1
`define FPU_FMSUB_S 2
`define FPU_FNMSUB_S 3
`define FPU_FNMADD_S 4

`define FPU_FADD_S 5
`define FPU_FSUB_S 6
`define FPU_FMUL_S 7
`define FPU_FDIV_S 8
`define FPU_FSQRT_S 9
`define FPU_FSGNJ_S 10
`define FPU_FSGNJN_S 11
`define FPU_FSGNJX_S 12
`define FPU_FMIN_S 13
`define FPU_FMAX_S 14
`define FPU_FCVT_W_S 15
`define FPU_FCVT_WU_S 16
`define FPU_FMV_X_W 17
`define FPU_FEQ_S 18
`define FPU_FLT_S 19
`define FPU_FLE_S 20
`define FPU_FCLASS_S 21
`define FPU_FCVT_S_W 22
`define FPU_FCVT_S_WU 23
`define FPU_FMV_W_X 24

//Floating point corner case definitions 
`define NaN 32'h7fc00000
`define PLUS_ZERO 32'h00000000
`define MINUS_ZERO 32'h80000000
`define PLUS_INFINITY 32'h7F800000
`define MINUS_INFINITY 32'hFF800000

`endif
