// subtractor module:
// Input:
    // [7:0] N_in - Input from N module
    // [3:0] curr_num - number from Square Root unit
// Output:
    // [7:0] next_N - equals to (N_in - curr_num)
    // B: B = 1 if N < curr_num; B = 0 if N > curr_num
module subtractor(
    input [7:0] N_in,
    input [4:0] curr_num,
    output [7:0] next_N,
    output reg B
);

assign next_N = N_in - curr_num;

always @(*) begin
    if (N_in < curr_num) begin
        B = 1;
    end else begin
        B = 0;
    end
end

endmodule