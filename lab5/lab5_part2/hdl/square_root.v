// square root module
// Input:
    // Inc - increment the register by 2
    // clk
    // rst - reset the initial integer to 1
// Output:
    // curr_num - current odd integer value
module square_root(
    input Inc,
    input clk,
    input rst,
    output reg [4:0] curr_num
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        curr_num <= 5'b00001;
    end else if (Inc) begin
        curr_num <= curr_num + 2;
    end
end

endmodule