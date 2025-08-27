module ram(
    input clk,
    input [3:0] addr,
    input mwr,
    input [3:0] mdi,
    output reg [3:0] mdo
);


reg [3:0] memory [15:0] /* synthesis ramstyle = "M9K" */;

initial begin
    integer i;
    for (i = 0; i < 16; i = i+1) begin
        memory[i] = 4'hF;
    end
end

always @ (posedge clk) begin
    if (mwr) memory[addr] <= mdi; //write mem
    mdo <= memory[addr]; // read mem
end

endmodule