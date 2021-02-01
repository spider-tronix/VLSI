`include "defines.v"

module FPU_control(input[1:0] FPUOp,
                   input[6:0] funct7,
                   input[2:0] funct3,
                   output reg [4:0]FPU_control_line,
                   input wire rst);
always @(*)
begin
    if (rst)
        FPU_control_line = 0;
    else begin
        case (FPUOp)
            3'b000: FPU_control_line = `FPU_FMADD_S;
            3'b001: FPU_control_line = `FPU_FMSUB_S;
            3'b010: FPU_control_line = `FPU_FNMSUB_S;
            3'b011: FPU_control_line = `FPU_FNMADD_S;
            3'b111: FPU_control_line = (funct7 == `FUNCT7_FADD_S)  ? `FPU_FADD_S:
                                       (funct7 == `FUNCT7_FSUB_S)  ? `FPU_FSUB_S:
                                       (funct7 == `FUNCT7_FMUL_S)  ? `FPU_FMUL_S:
                                       (funct7 == `FUNCT7_FDIV_S)  ? `FPU_FDIV_S:
                                       (funct7 == `FUNCT7_FSQRT_S) ? `FPU_FSQRT_S:
                                       ((funct7 == `FUNCT7_FSGNJ_S)   && (funct3 == `FUNCT3_FSGNJ_S))   ? `FPU_FSGNJ_S:
                                       ((funct7 == `FUNCT7_FSGNJN_S)  && (funct3 == `FUNCT3_FSGNJN_S))  ? `FPU_FSGNJN_S:
                                       ((funct7 == `FUNCT7_FSGNJX_S)  && (funct3 == `FUNCT3_FSGNJX_S))  ? `FPU_FSGNJX_S:
                                       ((funct7 == `FUNCT7_FMIN_S)    && (funct3 == `FUNCT3_FMIN_S))    ? `FPU_FMIN_S:
                                       ((funct7 == `FUNCT7_FMAX_S)    && (funct3 == `FUNCT3_FMAX_S))    ? `FPU_FMAX_S:
                                       (funct7 == `FUNCT7_FCVT_W_S)   ? `FPU_FCVT_W_S:
                                       (funct7 == `FUNCT7_FCVT_WU_S)  ? `FPU_FCVT_WU_S:
                                       ((funct7 == `FUNCT7_FMV_X_W)  && (funct3 == `FUNCT3_FMV_X_W))    ? `FPU_FMV_X_W:
                                       ((funct7 == `FUNCT7_FEQ_S)    && (funct3 == `FUNCT3_FEQ_S))      ? `FPU_FEQ_S:
                                       ((funct7 == `FUNCT7_FLT_S)    && (funct3 == `FUNCT3_FLT_S))      ? `FPU_FLT_S:
                                       ((funct7 == `FUNCT7_FLE_S)    && (funct3 == `FUNCT3_FLE_S))      ? `FPU_FLE_S:
                                       ((funct7 == `FUNCT7_FCLASS_S) && (funct3 == `FUNCT3_FCLASS_S))   ? `FPU_FCLASS_S:
                                       (funct7 == `FUNCT7_FCVT_S_W)   ? `FPU_FCVT_S_W:
                                       (funct7 == `FUNCT7_FCVT_S_WU)  ? `FPU_FCVT_S_WU:
                                       (funct7 == `FUNCT7_FMV_W_X)    ? `FPU_FMV_W_X: `FPU_NOP;
        endcase
    end
end
endmodule
