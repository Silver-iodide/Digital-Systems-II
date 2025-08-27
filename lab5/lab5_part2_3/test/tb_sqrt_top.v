`timescale 1ns / 1ps

module tb_sqrt_top;

    reg clk = 0;
    reg rst_n;
    reg st_btn;

    wire [6:0] HEX0, HEX1, HEX2;
    wire [9:0] LEDR;

    // 实例化被测模块
    sqrt_top uut (
    .MAX10_CLK1_50(clk),
    .KEY({rst_n, st_btn}),  // KEY[1] = rst_n, KEY[0] = st_btn
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .LEDR(LEDR)
    );

    // 50 MHz 时钟
    always #10 clk = ~clk;

    // 七段码转十进制数字函数
    function [3:0] hex_to_dec;
        input [6:0] seg;
        begin
            case (seg)
                7'b1000000: hex_to_dec = 0;
                7'b1111001: hex_to_dec = 1;
                7'b0100100: hex_to_dec = 2;
                7'b0110000: hex_to_dec = 3;
                7'b0011001: hex_to_dec = 4;
                7'b0010010: hex_to_dec = 5;
                7'b0000010: hex_to_dec = 6;
                7'b1111000: hex_to_dec = 7;
                7'b0000000: hex_to_dec = 8;
                7'b0011000: hex_to_dec = 9;
                default:    hex_to_dec = 15;  // 无效段码
            endcase
        end
    endfunction

    wire [3:0] HEX0_dec = hex_to_dec(HEX0);
    wire [3:0] HEX1_dec = hex_to_dec(HEX1);
    wire [3:0] HEX2_dec = hex_to_dec(HEX2);

    integer i;
    initial begin
        $display("=== START TESTING sqrt_top ===");
        rst_n = 0;
        st_btn = 0;

        #100;
        rst_n = 1;

        for (i = 0; i < 16; i = i + 1) begin
            // Start 脉冲
            #20 st_btn = 1;
            #20 st_btn = 0;

            // 等待 Done 高电平
            wait (LEDR[0] == 1);

            // 显示 √N 结果和输入值
            $display("√ RAM[%0d] = %0d → sqrt = %0d",
                     i, {HEX2_dec, HEX1_dec}, HEX0_dec);

            // 等待 Done 下降，避免跳多次
            wait (LEDR[0] == 0);
            #10;
        end

        $display("=== FINISHED TESTING ===");
        $stop;
    end

endmodule

