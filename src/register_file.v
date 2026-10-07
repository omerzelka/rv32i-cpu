module register_file(
    input wire clk,
    input wire rst,
    input wire write_en,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] wd,
    output wire [31:0] rd1,
    output wire [31:0] rd2
);
    
    integer i;
    reg [31:0] registers [0:31];

    assign rd1 = (rs1 == 5'b0) ? 32'b0 : registers[rs1];
    assign rd2 = (rs2 == 5'b0) ? 32'b0 : registers[rs2];

    always @(posedge clk) begin
        if(rst) begin
            for(i=0; i<32; i = i+1) begin
                registers[i] <= 32'b0;
            end
        end

        else if((write_en) && (rd != 5'b0)) begin
            registers[rd] <= wd;
        end    
    end

endmodule