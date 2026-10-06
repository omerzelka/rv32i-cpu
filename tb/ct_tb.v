`timescale 1ns/1ps
module ct_tb();
    reg clk;
    reg rst;
    wire [31:0] instruction;



    cpu_top uut(
        .clk(clk),
        .rst(rst),
        .instruction(instruction)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        $monitor("instruction=%h", instruction); 
        $dumpfile("sim/cpu_top.vcd");
        $dumpvars(0, ct_tb);

        rst = 1;
        #10 rst = 0;

        #40;
        $finish;
    end



endmodule