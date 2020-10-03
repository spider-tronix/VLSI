
`timescale 1 ns/ 1ps
/*
ALU Control Unit sends control signals to the ALU for performing different operations like add,subtract,AND,OR.
The convention followed for decoding is in accordance to Computer Organisation for RISCV book by Patterson. 

Inputs:
ALUOp - Input from control unit
Funct7, funct3 : Certain sections of instruction word 

Output(To ALU):
ALU_control_line : output signal
*/
module ALU_control( ALUOp,funct7,funct3,ALU_control_line, ALU_control_enable, clk);
input[1:0] ALUOp;
input[6:0] funct7;
input[2:0] funct3;
output reg [3:0] ALU_control_line;
input wire ALU_control_enable, clk;

always @(posedge clk)
begin
    if(ALU_control_enable)
    begin
        case(ALUOp)
            2'b00: ALU_control_line = 4'b0010;  //for opcodes ld,sd
            2'b01: ALU_control_line = 4'b0110;  //for opcode beq
            2'b10:begin if(funct7 == 7'b0000000 && funct3 == 3'b000)// for add operation 
                       begin
                       ALU_control_line = 4'b0010; //add signal
                       end 
                   else if(funct7 == 7'b0100000 && funct3 == 3'b000) //for subtraction operation
                       begin
                       ALU_control_line = 4'b0110; //subtract signal      
                       end
                   else if(funct7 == 7'b0000000 && funct3 == 3'b111)//for AND operation
                        begin
                        ALU_control_line = 4'b0000; //AND operation
                        end
                   else if(funct7 == 7'b0000000 && funct3 == 3'b110)//for OR operation
                        begin
                        ALU_control_line = 4'b0001; //OR operation
                        end
                   else begin
                   ALU_control_line = ALU_control_line;
                   end
                   end
        endcase 
    end
end
endmodule