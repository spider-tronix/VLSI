`include "defines.v"

`timescale 1ns / 1ps

module BranchControl #(parameter XLEN = 32)
                    (
                        input [XLEN-1:0] data1, data2,
                        input branch, jump,
                        input rst,
                        input[2:0] funct3,
                        output reg take_branch);
    always@ (*) begin
        take_branch = 0;
        if(rst)
            take_branch = 0;
        else begin
            if(jump)
            take_branch = 1;
            else if(branch) begin
                case (funct3)
						`FUNCT3_BEQ : begin
							if (data1 == data2) take_branch = 1;
						end
						`FUNCT3_BNE : begin
                            if (data1 != data2) take_branch = 1;
						end
						`FUNCT3_BLT : begin
							if ((data1 < data2)^(data1[31] != data2[31])) take_branch = 1;
						end
						`FUNCT3_BGE : begin
							if ((data1 >= data2)^(data1[31] != data2[31])) take_branch = 1;
						end
						`FUNCT3_BLTU : begin
							if (data1 <= data2) take_branch = 1;
						end
						`FUNCT3_BGEU : begin
							if (data1 >= data2) take_branch = 1;
						end
                endcase
            end
        end
    end
endmodule