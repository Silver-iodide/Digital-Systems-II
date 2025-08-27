module ram_m9k #(
    parameter M = 6,  // depth
    parameter K = 4   // data width
)(
    input clk,
    input [$clog2(M)-1:0] addr,
    input mwr,
    input [K-1:0] mdi,
    output reg [K-1:0] mdo
);

reg [K-1:0] memory [0:M-1] /* synthesis ramstyle = "M9K" */;

integer i;
initial begin
    for (i = 0; i < M; i = i + 1) begin
        memory[i] = {K{1'b1}};  // e.g., 4'hF if K=4
    end
end

always @(posedge clk) begin
    if (mwr)
        memory[addr] <= mdi;
    mdo <= memory[addr];
end

endmodule
