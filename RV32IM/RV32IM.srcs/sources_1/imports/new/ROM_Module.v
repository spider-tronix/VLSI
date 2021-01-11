/*
 Module Name: ROM_Module
 Description : Serves as the Program ROM memory from which instructions
 are fetched
 Specifications : Word size = 8 bits
 Depth = 2048
 Total Size = 2KB
 */
`timescale 1ns / 1ps

module ROM_Module #(parameter WORD_LENGTH = 32,
                    parameter ROM_DEPTH = 2048,
                    parameter XLEN = 32)
                   (input [XLEN-1:0] Addr,
                    input clk,
                    output reg mem_busy,
                    output reg [XLEN-1:0] Instr,
                    input ROM_Enable,
                    ROM_Rst);
    
    
    // (* KEEP = "TRUE" *) reg [WORD_LENGTH-1:0] ROM_mem[0:ROM_DEPTH-1];
    integer i;
    
    //Rom Write Block
    initial
    begin
        mem_busy <= 0;
        // $readmemh("Code.txt", ROM_mem);
        $display("Done Reading!!!!!!");
    end
    //Rom Read Block
    
    // always @(negedge clk)
    // begin
    //     if (ROM_Rst)
    //         for(i = 0;i<ROM_DEPTH;i = i+1)
    //         ROM_mem[i] <= 0;
    //     else
    //     if (ROM_Enable) begin
    //         Instr = ROM_mem[Addr];   //little endian format
    //         $display("IF Get Inst: %h\n", Instr);
    //     end
    // end
    always @(negedge clk)
    begin
        if (ROM_Enable) begin
            case(Addr)
                0: Instr  <= 32'hfe010113;
                1: Instr  <= 32'h00812e23;
                2: Instr  <= 32'h02010413;
                3: Instr  <= 32'h06400793;
                4: Instr  <= 32'hfef42623;
                5: Instr  <= 32'h00100793;
                6: Instr  <= 32'hfef42423;
                7: Instr  <= 32'hfec42703;
                8: Instr  <= 32'hfe842783;
                9: Instr  <= 32'h00f707b3;
                10: Instr <= 32'hfef42223;
                11: Instr <= 32'hfe442703;
                12: Instr <= 32'hfe842783;
                13: Instr <= 32'h00f75863;
                14: Instr <= 32'hfe842783;
                15: Instr <= 32'hfff78793;
                16: Instr <= 32'hfef42423;
                17: Instr <= 32'hfec42703;
                18: Instr <= 32'hfe442783;
                19: Instr <= 32'h40f707b3;
                20: Instr <= 32'hfef42423;
                21: Instr <= 32'h00000793;
                22: Instr <= 32'h00078513;
                23: Instr <= 32'h01c12403;
                24: Instr <= 32'h02010113;
                25: Instr <= 32'h00008067;                
            endcase
            $display("IF Get Inst: %h\n", Instr);
        end
    end
    
    
endmodule
