`timescale 1ns/1ps
module pc_tb();
    reg clk;
    reg rst;
    reg [31:0] next_pc;
    wire [31:0] pc;

    pc dut(
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc(pc)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        $dumpfile("sim/pc.vcd");
        $dumpvars(0, pc_tb);

        rst = 1'b1;
        next_pc = 32'b0;
        #5 rst = 0;
        #10 next_pc = next_pc + 32'd4;
        #10 next_pc = next_pc + 32'd4;
        #10 next_pc = next_pc + 32'd4;
        #10 next_pc = next_pc + 32'd4;
        #10 next_pc = next_pc + 32'd4;
        $finish;
    end

endmodule