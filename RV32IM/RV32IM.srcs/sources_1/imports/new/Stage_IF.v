`timescale 1ns / 1ps

module Stage_IF#(parameter XLEN = 32)
                (input [XLEN-1:0]PC,
                 input PC_ready,
                 branch,
                 input rst,
                 select,
                 output reg [XLEN-1:0]Instr,
                 output reg stallreq);
    
    reg using_mem;
    reg waiting;
    reg mem_re ;
    wire mem_busy;
    always @ (*) begin
        if (PC_ready) begin
            waiting = 0;
            //$display("Right one is here, %h", pc_i);
        end
            if (rst) begin
                stallreq  = 0;
                using_mem = 0;
                //PC      = 0;
                mem_re    = 0;
                waiting   = 0;
                end else if (branch) begin
                //$display("branch");
                //PC      = 0;
                using_mem = 0;
                mem_re    = 0;
                stallreq  = 0;
                waiting   = 1;
                end else if (!waiting && !mem_busy && !using_mem) begin
                //$display("!mem_busy && !using_mem");
                stallreq  = 1;
                using_mem = 1;
                mem_re    = 1;
                end else if (!waiting && !mem_busy && using_mem) begin
                //$display("!mem_busy && using_mem");
                stallreq  = 0;
                using_mem = 0;
                //PC      = pc_i;
                
                end else if (!waiting && mem_busy) begin
                //$display("mem_busy, %h", pc_i);
                stallreq = 1;
                end else if (!waiting) begin
                stallreq  = 0;
                using_mem = 0;
                //PC      = 0;
                Instr     = 0;
                mem_re    = 0;
                waiting   = 0;
            end
    end
    
    ROM_Module fetch_instr(
    .Addr(PC), .Instr(Instr), .mem_busy(mem_busy),
    .ROM_Enable(mem_re),.ROM_Rst(1'b0)
    );
    
endmodule
