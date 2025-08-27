// consumer module
// Inputs:
    // [K-1:0] data - from FIFO unit
    // empty - determine if there is data
    // read_clk - read clock, from top level unit (system_with_FIFO)
// Outputs:
    // read - send read request to the FIFO, wait for its data


// Algorithm:
// 3 states (2 registers): not_empty => wait_data => data_ready

// State not_empty: combinational logic, not_empty = ~empty 
// If FIFO has something, read <= 1; 
// Else: read <= 0 

// State wait_data: 
// Nothing to do, just wait for the data ready to use in the next state

// State data_ready: 
// ram[curr_B] <= data - 1; 
// If curr_B == M-1: curr_B <= 0;
// Else: curr_B <= curr_B + 1; 

module consumer
#(parameter M=6, parameter K=4)
(
    input [K-1:0] data,
    input empty,
    input read_clk,
    input rst, 
    output reg read
);

// Registers
reg [K-1:0] ram [M-1:0] /* synthesis ramstyle = "M9K" */;
reg wait_data, data_ready;
reg [M-1:0] curr_B;     // make sure B can represent the memory addr

// Sequential Logic for the three states
always @(posedge read_clk) begin
    wait_data <= ~empty;
    data_ready <= wait_data;
end


// Sequential logic for what to do in each state
always @(posedge read_clk or posedge rst) begin
    if (rst) begin
        wait_data <= 0;
        data_ready <= 0;
        curr_B <= 0;
    end

    else begin

        if (!empty) begin
            read <= 1;
        end else begin
            read <= 0;
        end

        if (data_ready) begin
            ram[curr_B] <= data - 1;
            if (curr_B == (M-1)) begin
                curr_B <= 0;
            end else begin
                curr_B <= curr_B + 1;
            end
        end

    end
end



endmodule
