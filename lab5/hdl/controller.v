// control unit
// Input: 
    // St - start the current square root calculation
    // B - will be set to 1 when the calculation done
    // Rst - Initialize to Start state
    // clk
// Output:
    // Load, Su, Inc, rst, Done
module controller(
    input St,
    input B,
    input Rst,
    input clk, 
    output reg Load, Su, Inc, rst, Done
);

// local wires/registers
reg [2:0] curr_state, next_state;

// state declaration
localparam start = 3'b000;
localparam checkB = 3'b001;
localparam update = 3'b010;
localparam increment = 3'b011;
localparam done = 3'b100;

// Sequential Logic
// If reset: curr_state <= start; 
// else, update current state as usual
always @(posedge clk) begin
    if (!Rst) begin
        curr_state <= start;
    end else begin
        curr_state <= next_state;
    end
end

// Combinational Logic
always @(*) begin
    case(curr_state)
        

        start: begin
            Load = 1;
            rst = 1;
            Su = 0;
            Inc = 0;
            Done = 0;
            if (St == 1) 
                next_state = checkB;
            else
                next_state = start; 
        end

        checkB: begin
            Load = 0;
            rst = 0;
            Su = 0;
            Inc = 0;
            Done = 0;
            if (B == 0)
                next_state = update;
            else
                next_state = done;
        end

        update: begin
            Load = 0;
            rst = 0;
            Su = 1;
            Inc = 0;
            Done = 0;
            next_state = increment;
        end

        increment: begin
            Load = 0;
            rst = 0;
            Su = 0;
            Inc = 1;
            Done = 0;
            next_state = checkB;
        end

        done: begin
            Load = 0;
            rst = 0;
            Su = 0;
            Inc = 0;
            Done = 1;
            if (St == 0)
                next_state = start;
            else
                next_state = done;
        end

        default: begin
            Load = 0;
            rst = 0;
            Su = 0;
            Inc = 0;
            Done = 0;
            next_state = start; // if jump to unexpected state, return to start state
        end
    endcase

end

endmodule