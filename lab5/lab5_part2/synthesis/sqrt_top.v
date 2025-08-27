module sqrt_top (
    input clk,
    input rst_n,
    input st_btn,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [9:0] LEDR
);

    reg [3:0] addr;
    reg st_prev;

    wire [7:0] ram_data_out;
    wire [7:0] ram_data_in;
    wire mwr = 1'b0;  
    wire [3:0] ram_addr = addr;

    wire Load, Su, Inc, Done, B;
    reg rst_sync;

    wire [7:0] curr_val;
    wire [4:0] curr_num;
    wire [7:0] next_N; 
    wire [3:0] Sqrt;

    ram mem (
        .clk(clk),
        .addr(ram_addr),
        .mwr(mwr),
        .mdi(8'b0),
        .mdo(ram_data_out)
    );

    controller ctrl (
        .St(st_btn),
        .B(B),
        .Rst(rst_sync),
        .clk(clk),
        .Load(Load),
        .Su(Su),
        .Inc(Inc),
        .rst(),
        .Done(Done)
    );

    N n_reg (
        .clk(clk),
        .N(ram_data_out),
        .subtractor_in(next_N),
        .Load(Load),
        .Su(Su),
        .curr_val(curr_val)
    );

    // square root generator
    square_root sqr_gen (
        .Inc(Inc),
        .clk(clk),
        .rst(rst_sync),
        .curr_num(curr_num)
    );

    // subtractor
    subtractor sub (
        .N_in(curr_val),
        .curr_num(curr_num),
        .next_N(next_N),
        .B(B)
    );

    assign Sqrt = curr_num[4:1];

    assign LEDR[0] = Done;

    always @(posedge clk) begin
        st_prev <= st_btn;
        if (~rst_n)
            addr <= 4'd0;
        else if (Done && st_prev == 0 && st_btn == 1) 
            addr <= (addr == 4'd15) ? 4'd0 : addr + 4'd1;
    end

    
    always @(posedge clk)
        rst_sync <= ~rst_n;

    // HEX 显示：用 HEX2/HEX1 显示 N，HEX0 显示 Sqrt
    hex_decoder hex0(.x(Sqrt), .seg(HEX0));
    hex_decoder hex1(.x(curr_val[3:0]), .seg(HEX1));
    hex_decoder hex2(.x(curr_val[7:4]), .seg(HEX2));

endmodule
