module consumer #(
    parameter M = 6,
    parameter K = 4
)(
    input [K-1:0] data,
    input empty,
    input read_clk,
    input rst, 
    output reg read,
    output reg [K-1:0] siu
);

// State registers
reg wait_data, data_ready;
reg [$clog2(M)-1:0] curr_B, curr_B_reg;
reg mwr;
wire [K-1:0] mdo;

// Instantiate RAM
ram_m9k #(.M(M), .K(K)) my_ram (
    .clk(read_clk),
    .addr(curr_B_reg),
    .mwr(mwr),
    .mdi(data - 1),
    .mdo(mdo)
);

always @(posedge read_clk or posedge rst) begin
    if (rst) begin
        wait_data <= 0;
        data_ready <= 0;
        curr_B <= 0;
        curr_B_reg <= 0;
        read <= 0;
        mwr <= 0;
        siu <= 0;
    end else begin
        wait_data <= ~empty;
        data_ready <= wait_data;
        curr_B_reg <= curr_B;
        siu <= mdo;

        read <= ~empty;
        mwr <= 0;

        if (data_ready) begin
            mwr <= 1;
            if (curr_B == M - 1)
                curr_B <= 0;
            else
                curr_B <= curr_B + 1;
        end
    end
end

endmodule
