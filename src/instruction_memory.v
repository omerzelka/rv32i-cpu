module instruction_memory (
    input wire [31:0] addr,
    output wire [31:0] instruction
);
    reg [31:0] mem [0:255];
    assign instruction = mem[addr[9:2]];
    initial begin
        $readmemh("programs/test.hex", mem);
    end
endmodule