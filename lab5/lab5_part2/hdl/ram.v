module ram(
    input clk,
    input [3:0] addr,
    input mwr,
    input [7:0] mdi,
    output reg [7:0] mdo
);

    reg [7:0] memory [15:0];  // 修改为 8-bit 宽
	 integer i;

    // 初始化 RAM 内容（可选）
    initial begin
        
        for (i = 0; i < 16; i = i + 1)
            memory[i] = 8'hFF;  // 可改为 testvecs 中的初始值
    end

    always @ (posedge clk) begin
        if (mwr)
            memory[addr] <= mdi; // 写操作
        mdo <= memory[addr];    // 读操作
    end

endmodule
