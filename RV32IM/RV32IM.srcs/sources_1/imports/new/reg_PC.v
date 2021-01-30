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
    reg br_occur;
    reg [31:0] branch_addr;
    // always@(posedge br) begin
    // if(br) begin
    //     br_occur = 1;
    //     branch_addr = br_addr;
    //     $display("Branch_addr set to : %h", branch_addr);
    // end
    // end

    always @ (posedge clk) begin
        if (!rst && br) begin
            PC       = br_addr;
            PC_ready = 1;
            // pc_o       = branch_addr;
            // PC_ready_o = 1;
            // br_occur = 0;
            $display("PC updated to: %h", PC);

            end else if (!rst && !stall[0]) begin
            $display("PC increase to: %h", PC);

            PC       = PC + 1;
            PC_ready = 0;
        end
             if (rst) begin
                pc_o     = -1;
                PC_ready = 0;
                PC       = -1;
                PC_ready_o =0;
                br_occur = 0;
                end else if (!stall[0]) begin
                $display("PC now: %h", PC);
                pc_o       = PC;
                PC_ready_o = PC_ready;
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
