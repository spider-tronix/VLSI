`include "defines.v"
`timescale 1ns / 1ps

module ALU_Module #(parameter XLEN = 32,
                    parameter ALU_SELECT_SIZE = 5)
                   (input[XLEN-1:0] rs1,
                    rs2,
                    input ALU_Reset,
                    ALU_Enable,
                    input [ALU_SELECT_SIZE-1:0] ALUOp,
                    output reg[XLEN-1:0] result,
                    output zero_flag);
    
    assign zero_flag = (result == 0)?1'b1:1'b0; //zero is true if result is zero
    
    
    always @(*)
        if (ALU_Reset)
            result <= 0;
        else begin
            case (ALUOp[4:0])
                `EXE_NOP_OP: ;                             //No operation
                `EXE_AND_OP: result <= rs1 & rs2;          //AND
                `EXE_OR_OP : result <= rs1 | rs2;          //OR
                `EXE_XOR_OP: result <= rs1 ^ rs2;          //XOR
                
                `EXE_SLL_OP: result <= rs1 << rs2;         //Left Shift
                `EXE_SRL_OP: result <= rs1 >> rs2;         //Right Shift
                `EXE_SRA_OP: ;
                
                `EXE_ADD_OP: result <= rs1 + rs2;              // Add
                `EXE_SUB_OP: result <= rs1 - rs2;            //Subtract
                `EXE_SLT_OP: result <= (rs1[31] == rs2[31]) ? (rs1 < rs2) : {31'b0,rs1[31]} ;
                `EXE_SLTU_OP: result <= (rs1 < rs2);
                
                `EXE_BEQ_OP: result <= (rs1 == rs2) ;
                `EXE_BNE_OP: result <= (rs1!= rs2) ;
                `EXE_BLT_OP: result <= (rs1 < rs2)^(rs1[31] != rs2[31]) ;
                `EXE_BGE_OP: result <= (rs1 >= rs2)^(rs1[31] != rs2[31]) ;
                `EXE_BLTU_OP: result <= (rs1 < rs2) ;
                `EXE_BGEU_OP: result <= (rs1 >= rs2) ;
                
                /*      `EXE_LB_OP: result <= rs1 + rs2;
                 `EXE_LH_OP: result        <= rs1 + rs2;
                 `EXE_LW_OP: result        <= rs1 + rs2;
                 `EXE_LBU_OP: result       <= rs1 + rs2;
                 `EXE_LHU_OP: result       <= rs1 + rs2;
                 `EXE_SB_OP: result        <= rs1 + rs2;
                 `EXE_SH_OP: result        <= rs1 + rs2;
                 `EXE_SW_OP: result        <= rs1 + rs2;
                 */
                default: result <= rs1+1;
            endcase
        end
    
endmodule
