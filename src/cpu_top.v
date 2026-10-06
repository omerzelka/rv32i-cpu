module cpu_top(
    input wire clk,
    input wire rst,
    output wire [31:0] instruction
);

    wire [31:0] pc;
    wire [31:0] next_pc;

    assign next_pc = pc + 4;

    pc u_pc(
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .next_pc(next_pc)
    );

    instruction_memory u_im(
        .addr(pc),
        .instruction(instruction)
    );

endmodule