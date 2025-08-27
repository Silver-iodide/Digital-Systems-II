// Top level design module for lab7 part 2
// Three modules: producer, fifo, consumer
// Inputs:
    // write_clock, read_clock
    // rst

module system_with_FIFO
#(  parameter K = 4,    // data bit width
    parameter N = 4,    // FIFO depth 
    parameter M = 6    // internal memory depth
)
(
    input write_clk, read_clk,
    input rst,
    output [$clog2(N):0] dataNum_in_FIFO
);

// internal signals and registers
wire write, read;                   // write and read request from producer and consumer
wire [K-1:0] data_in, data_out;     // data_in from producer, data_out to consumer 
wire full, empty; 
wire [K-1:0] siu;

// instantiate modules

producer #(.M(M), .K(K)) PRODUCER (
    .write_clk(write_clk), 
    .full(full),
    .rst(rst),
    .data_out(data_in), .write(write)
);

fifo_async_clk #(.K(K), .N(N)) FIFO (
    .write_clk(write_clk), .read_clk(read_clk), .rst(rst),
    .write(write), .read(read),
    .din(data_in), .dout(data_out),
    .full(full), .empty(empty),
    .D(dataNum_in_FIFO)
);

consumer #(.M(M), .K(K)) CONSUMER (
    .data(data_out),
    .empty(empty),
    .read_clk(read_clk), .rst(rst),
    .read(read),
	 .siu(siu)
);

endmodule