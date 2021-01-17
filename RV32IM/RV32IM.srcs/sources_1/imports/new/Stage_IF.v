`timescale 1ns / 1ps

module Stage_IF#(parameter XLEN = 32)
                (
                 input [XLEN-1:0]PC,
                 input PC_ready,
                 branch,
                 input rst,
                 select,
                //  clk,
                 input wire mem_busy,
                 output reg mem_re,
                //  output [XLEN-1:0]Instr,
                 output reg stallreq);
    
    reg using_mem;
    reg waiting;
    // reg mem_re ;
    // wire mem_busy;
    reg br_occur = 0;
    // always@(posedge branch) begin
    // if(branch) begin
    //     br_occur = 1;
    // end 
    // end 
    always @ (*) begin
        if (PC_ready) begin
            waiting = 0;
            br_occur = 0;
            //$display("Right one is here, %h", pc_i);
        end
            if (rst) begin
                $display("STAGE_IF reset!!");
                stallreq  = 0;
                using_mem = 0;
                //PC      = 0;
                mem_re    = 0;
                waiting   = 0;
                end else if (branch) begin
                $display("STAGE_IF branch");
                //PC      = 0;
                using_mem = 0;
                mem_re    = 0;
                stallreq  = 0;
                waiting   = 1;
                end else if (!waiting && !mem_busy && !using_mem) begin
                // $display("!mem_busy && !using_mem");
                stallreq  = 0;
                using_mem = 1;
                mem_re    = 1;
                end else if (!waiting && !mem_busy && using_mem) begin
                $display("!mem_busy && using_mem");
                stallreq  = 0;
                using_mem = 0;
                //PC      = pc_i;
                
                end else if (!waiting && mem_busy) begin
                $display("mem_busylast");
                stallreq = 1;
                end else if (!waiting) begin
                $display("hopeless");
                stallreq  = 0;
                using_mem = 0;
                //PC      = 0;
//                Instr     = 0;
                mem_re    = 0;
                waiting   = 0;
            end
    end
    
    // ROM_Module fetch_instr(
    // .clk(clk),
    // .Addr(PC), .Instr(Instr), .mem_busy(mem_busy),
    // .ROM_Enable(mem_re),.ROM_Rst(1'b0)
    // );
    
endmodule
