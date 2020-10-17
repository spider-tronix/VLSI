
`timescale 1 ns/ 1ps
/*
ALU Control Unit sends control signals to the ALU for performing different operations like add,subtract,AND,OR.
The convention followed for decoding is in accordance to Computer Organisation for RISCV book by Patterson. 

Inputs:
ALUOp - Input from control unit
Funct7, funct3 : Certain sections of instruction word 

Output(To ALU):
ALU_control_line : output signal, 
*/
`include "defines.v"

module ALU_control(input[1:0] ALUOp,input[6:0] funct7,input[2:0] funct3, output reg [3:0]ALU_control_line, input wire ALU_control_enable, clk);

always @(posedge clk)
begin
    if(ALU_control_enable)
    begin
        case(ALUOp)
            2'b00: ALU_control_line = 4'b0010;  //for opcodes ld,sd (acc to book)
            2'b01: ALU_control_line = 4'b0110;  //for opcode beq (acc to book)
            // changes made acc to defines.v file
            2'b10:begin if(funct7 == `FUNCT7_ADD && funct3 == `FUNCT3_ADD_SUB)// for add operation 
                       begin
                       ALU_control_line = `EXE_ADD_OP; //add signal
                       end 
                   else if(funct7 == `FUNCT7_SUB && funct3 == `FUNCT3_ADD_SUB) //for subtraction operation
                       begin
                       ALU_control_line = `EXE_SUB_OP; //subtract signal      
                       end
                   else if(funct7 == `FUNCT7_AND && funct3 == `FUNCT3_AND)//for AND operation
                        begin
                        ALU_control_line = `EXE_AND_OP; //AND operation
                        end
                   else if(funct7 == `FUNCT7_OR && funct3 == `FUNCT3_OR)//for OR operation
                        begin
                        ALU_control_line = `EXE_OR_OP; //OR operation
                        end
                   //Added extra functions 
                   else if(funct7 == `FUNCT7_SLL && funct3 == `FUNCT3_SLL)//for SLL operation
                        begin
                        ALU_control_line = `EXE_SLL_OP; //OR operation
                        end
                   else if(funct7 == `FUNCT7_SRL && funct3 == `FUNCT3_SRL_SRA)//for SRL operation
                        begin
                        ALU_control_line = `EXE_SRL_OP; //SLT operation
                        end
                   else if(funct7 == `FUNCT7_SLT && funct3 == `FUNCT3_SLT)//for SRL operation
                        begin
                        ALU_control_line = `EXE_SLT_OP; //SLT operation
                        end
                   else begin
                   ALU_control_line = ALU_control_line;
                   end
                   end
        endcase 
    end
end
endmodule