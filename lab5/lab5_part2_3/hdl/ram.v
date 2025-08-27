module ram (
    input clk,
    input [3:0] addr,
    input mwr,
    input [7:0] mdi,
    output reg [7:0] mdo
);

    reg [7:0] memory [15:0];  // 16x8 RAM

    integer i;

    // 初始化 RAM 内容 + 打印验证
    initial begin
        memory[0]  = 8'd1;
        memory[1]  = 8'd4;
        memory[2]  = 8'd9;
        memory[3]  = 8'd16;
        memory[4]  = 8'd25;
        memory[5]  = 8'd36;
        memory[6]  = 8'd49;
        memory[7]  = 8'd64;
        memory[8]  = 8'd0;
        memory[9]  = 8'd6;
        memory[10] = 8'd13;
        memory[11] = 8'd21;
        memory[12] = 8'd27;
        memory[13] = 8'd44;
        memory[14] = 8'd225;
        memory[15] = 8'd255;

        // 打印每个 RAM 初值
        $display("=== RAM Initialization ===");
        for (i = 0; i < 16; i = i + 1)
            $display("memory[%0d] = %0d", i, memory[i]);
        $display("==========================");
    end

    // 写入 / 读取逻辑
    always @(posedge clk) begin
        if (mwr)
            memory[addr] <= mdi;    // 写入
        mdo <= memory[addr];        // 读取
    end

endmodule
