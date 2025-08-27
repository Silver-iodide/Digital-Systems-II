`timescale 1ns / 1ps

module tb_sqrt_top;

    // Inputs
    reg clk = 0;
    reg rst_n;
    reg st_btn;

    // Outputs
    wire [6:0] HEX0, HEX1, HEX2;
    wire [9:0] LEDR;

    sqrt_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .st_btn(st_btn),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .LEDR(LEDR)
    );

    always #10 clk = ~clk;

    integer i;
    initial begin
        $display("=== Square Root Testbench Start ===");

        rst_n = 0;
        st_btn = 0;

        #100;
        rst_n = 1;

        for (i = 0; i < 16; i = i + 1) begin
            
            #20 st_btn = 1;
            #20 st_btn = 0;

            
				
            wait (LEDR[0] == 1);

            $display("RAM[%0d] = %0d, Sqrt = %0d", i, {HEX2_dec, HEX1_dec}, HEX0_dec);

            wait (LEDR[0] == 0);
        end

        $display("=== Square Root Testbench Finished ===");
        $stop;
    end

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
                default:    hex_to_dec = 15;
            endcase
        end
    endfunction

    wire [3:0] HEX2_dec = hex_to_dec(HEX2);
    wire [3:0] HEX1_dec = hex_to_dec(HEX1);
    wire [3:0] HEX0_dec = hex_to_dec(HEX0);

endmodule
