`timescale 1ns / 1ps
module reg_PC (input wire clk,
               input wire rst,
               input wire [5:0] stall,
               input wire br,
               input wire [31:0] br_addr,
               output reg [31:0] pc_o,
               output reg PC_ready_o);
    
    reg [31:0] PC;
    reg        PC_ready;
    
    always @ (posedge clk) begin
        if (!rst && br) begin
            PC       <= br_addr;
            PC_ready <= 1;
            end else if (!rst && !stall[0]) begin
            PC       <= PC + 1;
            PC_ready <= 0;
        end
            if (rst) begin
                pc_o     <= 0;
                PC_ready <= 0;
                PC       <= 0;
                PC_ready_o <=0;
                end else if (!stall[0]) begin
                //$display("PC now: %h", PC);
                pc_o       <= PC;
                PC_ready_o <= PC_ready;
            end
    end
    
    /*always @ (posedge clk) begin
     if (rst) begin
     pc_o <= 0;
     end else if (!stall[0]) begin
     if (br) pc_o <= br_addr;
     else pc_o    <= pc_o + 4;
     end
     end*/
    
endmodule
