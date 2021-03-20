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
assign A_op1 = (M_enable)?M_result:op1;
assign A_op2 = (M_enable)?op3:op2;

//Comparator
reg COMP_enable;
wire [2:0]comp_result;
reg [FLEN-1:0] comp1, comp2;

//Float to int converter 
reg  F_to_I_CONV_enable,float_to_int,sign_f_to_i; 
reg [FLEN-1:0]  F_to_I_data;
wire [FLEN-1:0] F_to_I_conv_result;

//Int to float converter 
reg I_to_F_CONV_enable; reg sign_i_to_f;
reg [FLEN-1:0] I_to_F_data;
wire [FLEN-1:0] I_to_F_conv_result;


//Classify instruction 
reg [9:0] mask;

FloatingMultiplication Mult_unit(.enable(M_enable), .A(op1), .B(op2), .result(M_result) );
FloatingAddition Add_unit(.enable(A_enable), .subract_A(Sub_A), .subract_B(Sub_B), .A(A_op1), .B(op2), .result(A_result));
FloatingDivision Div_unit(.enable(D_enable), .A(op1), .B(op2), .result(D_result));
FloatingSqrt Sqrt_unit(.enable(SQRT_enable), .A(op1), .result(SQRT_result));
FloatingComparator Comp(.enable(COMP_enable), .A(comp1), .B(comp2), .result_comp(comp_result));

// Float_to_int_converter F_TO_I_Conv(.enable(F_to_I_CONV_enable), .float_to_int(float_to_int), .sign(sign_f_to_i), .data(F_to_I_conv_result),.result_conv(F_to_I_conv_result));
// Int_to_float_converter I_TO_F_Conv(.enable(I_to_F_CONV_enable), .sign(sign_i_to_f), .int_data(I_to_F_data),
//                                      .float_result(I_to_F_conv_result));
Float_to_int_converter F_TO_I_Conv(.enable(F_to_I_CONV_enable), .sign(sign_f_to_i), .data(F_to_I_data), .result_conv(F_to_I_conv_result));
Int_to_float_converter I_TO_F_Conv(.enable(I_to_F_CONV_enable), .sign(sign_i_to_f), .int_data(I_to_F_data), .float_result(I_to_F_conv_result));
always @(*) begin
    F_to_I_CONV_enable<=0;
    I_to_F_CONV_enable<=0;
    COMP_enable <= 0 ;
    M_enable <= 1;
    D_enable <= 0;
    A_enable <= 0;
    Sub_A <= 0;
    Sub_B <= 0;
    SQRT_enable <= 0;
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
                            result <= (comp_result == 'b001 || comp_result == 'b110 )? rs1:(( comp_result == 'b111)? `NaN: rs2);  //if A<B, comp_result = 001
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
                            result <= (comp_result == 'b010 || comp_result == 'b110 )? rs1:(( comp_result == 'b111)? `NaN: rs2); //if A>B, comp_result = 010
            end
         //to do
            `FPU_FCVT_W_S: //float to signed int  
                        begin
                        M_enable <= 0;
                         D_enable <= 0;
                         A_enable <= 0;
                         COMP_enable <=0;
                         F_to_I_CONV_enable<=1;
                         sign_f_to_i <=1;
                         F_to_I_data<= rs1;
                         float_to_int <=1;
                         result <= F_to_I_conv_result;
                    end     
            `FPU_FCVT_WU_S: //float to unsigned int 
            begin           M_enable <= 0;
                             D_enable <= 0;
                             A_enable <= 0;
                             COMP_enable <=0;
                             F_to_I_CONV_enable<=1;
                             sign_f_to_i <=0;
                             F_to_I_data<= rs1;
                             float_to_int <=1;
                             result <= F_to_I_conv_result;
             end
            `FPU_FMV_X_W: //need to verify
                begin 
                result <= rs1;
                end
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
                            result <= (comp_result == 'b000)?1:0; //if A=B, comp_result = 00
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
                            result <= (comp_result == 'b001)?1:0; //if A<B, comp_result = 01
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
                                    result <= (comp_result == 'b001 || comp_result == 'b000 )?1:0; //if A<B, comp_result = 01
                            end
            `FPU_FCLASS_S: begin 
                            if(rs1 == `PLUS_ZERO)
                                mask[4] <= 1;
                             else if( rs1 == `MINUS_ZERO)
                                mask[3] <= 1;
                             else if(rs1 == `MINUS_INFINITY)
                                mask[0] <= 1; 
                             else if(rs1 == `PLUS_INFINITY)
                                mask[7] <= 1;
                             else if(32'h7F800001<=rs1<= 32'h7FBFFFFF || 32'hFF800001<= rs1<= 32'hFFBFFFFF)
                                mask[8] <=1; //Signalling NAN
                             else if(32'h7FC00000<=rs1<=32'h7FFFFFFF || 32'hFFC00000<=rs1<=32'hFFFFFFFF)
                                mask[9] <=1;  //Quiet NAN 
                             //subnormal numbers 
                             else if( 32'h00800000<=rs1 <= 32'h007fffff)
                                mask[5] <=1;//positive subnormal 
                             else if(32'h80800000<=rs1<=32'h807fffff )
                                mask[2] <=1;    //negative subnormal
                             else if(rs1[31] == 1)
                                mask[1] <=1;
                             else if(rs1[31] == 0)
                                mask[6] <=1;
                             
                             result <= mask;            
                            end
            `FPU_FCVT_S_W://signed int to float
                        begin 
                        I_to_F_CONV_enable<=1;   
                        sign_i_to_f <=1;
                        I_to_F_data <= rs1;
                        result <=  I_to_F_conv_result;
                        end 
            `FPU_FCVT_S_WU://unsigned int to float 
                begin 
                I_to_F_CONV_enable<=1;   
                sign_i_to_f <=0;
                I_to_F_data <= rs1;
                result <=  I_to_F_conv_result;
                end
            `FPU_FMV_W_X://need to verify
            begin 
            result <= rs1;
            end 
        endcase
    end
end
endmodule            
