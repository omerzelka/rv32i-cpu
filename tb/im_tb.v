`timescale 1ns/1ps
module im_tb();

    wire [31:0] instruction;
    reg [31:0] addr;

    instruction_memory dut(
        .instruction(instruction),
        .addr(addr)
    );

    initial begin
        $monitor("addr=%h instruction=%h", addr, instruction); 
        $dumpfile("sim/instruction_memory.vcd");
        $dumpvars(0,im_tb);

        addr = 0; #10
        addr = 4; #10
        addr = 8; #10
        addr = 12; #10
        $finish;

    end

endmodule