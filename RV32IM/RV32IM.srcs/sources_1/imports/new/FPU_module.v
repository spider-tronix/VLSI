`timescale 1ns / 1ps
`include "defines.v"

module FPU_module#(parameter FLEN= 32)
                (input[FLEN-1:0] rs1, rs2, rs3,
                input [4:0]FPU_control_line,
                input wire rst,
                output reg [FLEN-1:0] result);
reg [FLEN-1:0] op1, op2, op3;
wire [FLEN-1:0] A_op1, A_op2;
wire [FLEN-1:0] M_result, D_result, A_result, S_result, SQRT_result;
reg M_enable, D_enable, A_enable, Sub_A, Sub_B, SQRT_enable;
reg COMP_enable; 
reg [2:0]comp_result;
reg [FLEN-1:0] comp1, comp2;
assign A_op1 = (M_enable)?M_result:op1;
assign A_op2 = (M_enable)?op3:op2;


FloatingMultiplication Mult_unit(.enable(M_enable), .A(op1), .B(op2), .result(M_result) );
FloatingAddition Add_unit(.enable(A_enable), .subract_A(Sub_A), .subract_B(Sub_B), .A(A_op1), .B(op2), .result(A_result));
FloatingDivision Div_unit(.enable(D_enable), .A(op1), .B(op2), .result(D_result));
FloatingSqrt Sqrt_unit(.enable(SQRT_enable), .A(op1), .result(SQRT_result));
FloatingComparator Comp(.enable(COMP_enable), .A(comp1), .B(comp2), .result_comp(comp_result));

always @(*) begin
    if(rst)
        result<=0;
    else begin
        case(FPU_control_line)
            `FPU_NOP: ;
            `FPU_FMADD_S: begin
                            M_enable <= 1;
                            D_enable <= 0;
                            A_enable <= 1;
                            COMP_enable <= 0 ;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= rs1;
                            op2 <= rs2;
                            op3 <= rs3; 
                            result <= A_result;
            end
            `FPU_FMSUB_S:begin
                            M_enable <= 1;
                            D_enable <= 0;
                            A_enable <= 1;
                            COMP_enable <=0;
                            Sub_A <= 0;
                            Sub_B <= 1;
                            SQRT_enable <= 0;
                            op1 <= rs1;
                            op2 <= rs2;
                            op3 <= rs3; 
                            result <= A_result;
            end
            `FPU_FNMSUB_S:begin
                            M_enable <= 1;
                            D_enable <= 0;
                            A_enable <= 1;
                            COMP_enable <=0;
                            Sub_A <= 1;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= rs1;
                            op2 <= rs2;
                            op3 <= rs3; 
                            result <= A_result;
            end
            `FPU_FNMADD_S:begin 
                            M_enable <= 1;
                            D_enable <= 0;
                            A_enable <= 1;
                            COMP_enable <=0;
                            Sub_A <= 1;
                            Sub_B <= 1;
                            SQRT_enable <= 0;
                            op1 <= rs1;
                            op2 <= rs2;
                            op3 <= rs3; 
                            result <= A_result;
            end
            `FPU_FADD_S:begin
                            M_enable <= 0;
                            D_enable <= 0;
                            A_enable <= 1;
                            COMP_enable <=0;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= rs1;
                            op2 <= rs2;
                            op3 <= 'b0; 
                            result <= A_result;
            end
            `FPU_FSUB_S:begin
                            M_enable <= 0;
                            D_enable <= 0;
                            A_enable <= 1;
                            COMP_enable <=0;
                            Sub_A <= 0;
                            Sub_B <= 1;
                            SQRT_enable <= 0;
                            op1 <= rs1;
                            op2 <= rs2;
                            op3 <= 'b0; 
                            result <= A_result;
            end
            `FPU_FMUL_S:begin
                            M_enable <= 1;
                            D_enable <= 0;
                            A_enable <= 0;
                            COMP_enable <=0;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= rs1;
                            op2 <= rs2;
                            op3 <= 'b0; 
                            result <= M_result;
            end
            `FPU_FDIV_S:begin
                            M_enable <= 0;
                            D_enable <= 1;
                            A_enable <= 0;
                            COMP_enable <= 0;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= rs1;
                            op2 <= rs2;
                            op3 <= 'b0; 
                            result <= D_result;
            end
            `FPU_FSQRT_S:begin
                            M_enable <= 0;
                            D_enable <= 0;
                            A_enable <= 0;
                            COMP_enable<=0;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 1;
                            op1 <= rs1;
                            op2 <= 'b0;
                            op3 <= 'b0; 
                            result <= SQRT_result;
            end
            `FPU_FSGNJ_S:begin
                            M_enable <= 0;
                            D_enable <= 0;
                            A_enable <= 0;
                            COMP_enable <=0;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= 'b0;
                            op2 <= 'b0;
                            op3 <= 'b0; 
                            result <= {(rs2[31]), rs1[30:0]};
            end
            `FPU_FSGNJN_S:begin
                            M_enable <= 0;
                            D_enable <= 0;
                            A_enable <= 0;
                            COMP_enable <=0;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= 'b0;
                            op2 <= 'b0;
                            op3 <= 'b0; 
                            result <= {(~rs2[31]), rs1[30:0]};
            end
            `FPU_FSGNJX_S:begin
                            M_enable <= 0;
                            D_enable <= 0;
                            A_enable <= 0;
                            COMP_enable <=0;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= 'b0;
                            op2 <= 'b0;
                            op3 <= 'b0; 
                            result <= {(rs1[31] ^ rs2[31]), rs1[30:0]};
            end
            `FPU_FMIN_S:begin
                            M_enable <= 0;
                            D_enable <= 0;
                            A_enable <= 0;
                            COMP_enable <=1;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= 'b0;
                            op2 <= 'b0;
                            op3 <= 'b0; 
                            comp1 <= rs1;
                            comp2 <= rs2;
                            result <= (comp_result == 001 || 110 )? rs1:(( comp_result == 111)? NaN: rs2);  //if A<B, comp_result = 001
            end
            `FPU_FMAX_S:begin 
                            M_enable <= 0;
                            D_enable <= 0;
                            A_enable <= 0;
                            COMP_enable <=1;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= 'b0;
                            op2 <= 'b0;
                            op3 <= 'b0; 
                            comp1 <= rs1;
                            comp2 <= rs2;
                            result <= (comp_result == 010 || 110 )? rs1:(( comp_result == 111)? NaN: rs2); //if A>B, comp_result = 010
            end
         //to do
            `FPU_FCVT_W_S:
            `FPU_FCVT_WU_S:
            `FPU_FMV_X_W:
            `FPU_FEQ_S: begin
                            M_enable <= 0;
                            D_enable <= 0;
                            A_enable <= 0;
                            COMP_enable <=1;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= 'b0;
                            op2 <= 'b0;
                            op3 <= 'b0; 
                            comp1 <= rs1;
                            comp2 <= rs2;
                            result <= (comp_result ==000)?1:0; //if A=B, comp_result = 00
            end           
            `FPU_FLT_S:begin
                            M_enable <= 0;
                            D_enable <= 0;
                            A_enable <= 0;
                            COMP_enable <=1;
                            Sub_A <= 0;
                            Sub_B <= 0;
                            SQRT_enable <= 0;
                            op1 <= 'b0;
                            op2 <= 'b0;
                            op3 <= 'b0; 
                            comp1 <= rs1;
                            comp2 <= rs2;
                            result <= (comp_result ==001)?1:0; //if A<B, comp_result = 01
                    end
            `FPU_FLE_S:begin
                                    M_enable <= 0;
                                    D_enable <= 0;
                                    A_enable <= 0;
                                    COMP_enable <=1;
                                    Sub_A <= 0;
                                    Sub_B <= 0;
                                    SQRT_enable <= 0;
                                    op1 <= 'b0;
                                    op2 <= 'b0;
                                    op3 <= 'b0; 
                                    comp1 <= rs1;
                                    comp2 <= rs2;
                                    result <= (comp_result == 001 || 000 )?1:0; //if A<B, comp_result = 01
               
                            end
            `FPU_FCLASS_S:
            `FPU_FCVT_S_W:
            `FPU_FCVT_S_WU:
            `FPU_FMV_W_X:
        endcase
    end
end
endmodule            
