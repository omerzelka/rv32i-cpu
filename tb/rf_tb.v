`timescale 1ns/1ps
module rf_tb();
    reg clk;
    reg rst;
    reg write_en;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] wd;
    wire [31:0] rd1;
    wire [31:0] rd2;

    integer errors;

    register_file uut(
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    always begin
        #5 clk = ~clk;
    end

    // Register'a yazma: girisleri negedge'de ver, posedge'de yazilsin
    task write_reg(input [4:0] addr, input [31:0] data);
        begin
            @(negedge clk);
            rd = addr;
            wd = data;
            write_en = 1;
            @(negedge clk);
            write_en = 0;
        end
    endtask

    // Okunan degeri beklenenle karsilastir
    task check(input [255:0] name, input [31:0] actual, input [31:0] expected);
        begin
            if (actual === expected)
                $display("PASS  %0s: %h", name, actual);
            else begin
                $display("FAIL  %0s: okunan=%h beklenen=%h", name, actual, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        clk = 0;
        errors = 0;
        write_en = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        wd = 0;
        $dumpfile("sim/register_file.vcd");
        $dumpvars(0,rf_tb);
        rst = 1;
        #10 rst = 0;

        // 1) Reset sonrasi tum register'lar 0 olmali
        rs1 = 5; rs2 = 31; #1;
        check("reset x5 ", rd1, 32'h0);
        check("reset x31", rd2, 32'h0);

        // 2) Yazma + okuma
        write_reg(5, 32'hdeadbeef);
        rs1 = 5; #1;
        check("x5 yaz/oku", rd1, 32'hdeadbeef);

        // 3) Iki port ayni anda
        write_reg(6, 32'h12345678);
        rs1 = 5; rs2 = 6; #1;
        check("port1 x5", rd1, 32'hdeadbeef);
        check("port2 x6", rd2, 32'h12345678);

        // 4) write_en = 0 iken yazma olmamali
        @(negedge clk);
        rd = 5; wd = 32'hffffffff; write_en = 0;
        @(negedge clk);
        rs1 = 5; #1;
        check("we=0 x5", rd1, 32'hdeadbeef);

        // 5) x0'a yazma etkisiz olmali
        write_reg(0, 32'hcafebabe);
        rs1 = 0; #1;
        check("x0 sabit", rd1, 32'h0);

        if (errors == 0)
            $display("TUM TESTLER GECTI");
        else
            $display("%0d TEST BASARISIZ", errors);

        $finish;
    end

endmodule