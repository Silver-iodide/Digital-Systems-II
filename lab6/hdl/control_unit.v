// Control unit:
// Inputs:
    // rst - reset the control unit
    // St - start signal, start loading the dividend and divisor 
    // C - equals 1 if current value needs to be updated
    // clk - clock signal
// Outputs:
    // Su - write enable, go to dividend unit
    // Sh - shift left enable, go to dividend unit
    // Ld - load enable, go to dividend unit
    // lc - load counter, go to dividend & divisor unit for data loading
// Internal register:
    // lc - load counter, wil be updated every time current state is 'load'. If lc = 3, next state will be 'shift' state 
    // sc - shift counter, will be updated every time current state is 'shift'. If sc = 16, the calculation should be finished 

module control_unit(
    input rst, St, C, clk,
    output reg Su, Sh, Ld, Rdy,
	 output reg [1:0] lc
);

reg [4:0] sc;
reg [2:0] curr_state, next_state;

localparam reset = 3'b000;
localparam load = 3'b001;
localparam shift = 3'b010;
localparam update = 3'b011;
localparam done = 3'b100;
// wait for one more clock cycle for the remainder being updated 
localparam shift_wait = 3'b101;

// FSM logic
// The load counter and shift counter being updated in this block
always @(posedge clk or posedge rst) begin

    if (rst) begin
        curr_state <= reset;
        lc <= 0;
        sc <= 0;
    end else begin
        curr_state <= next_state;
        if (next_state == load)
            lc <= lc + 1;
        if (next_state == shift)
            sc <= sc + 1;
    end
end

// Next state and output logic 
always @(*) begin
    case(curr_state)

        reset: begin
            if (St) begin
                next_state = load;
            end else begin
                next_state = reset;
            end
            Su = 0;
            Sh = 0;
            Ld = 0;
            Rdy = 0;
        end

        load: begin
            if (lc == 3) begin
                next_state = shift;
            end else begin
                next_state = load;
            end
            Ld = 1;
            Su = 0;
            Sh = 0;
            Rdy = 0; 
        end

        shift: begin
            next_state = shift_wait;
            Sh = 1;
            Su = 0;
            Ld = 0;
            Rdy = 0;
        end

        shift_wait: begin
            if (C == 0) begin
                if (sc == 16) begin
                    next_state = done;
                end else begin
                    next_state = shift; 
                end
            end else begin
                next_state = update;
            end
            Sh = 0;
            Su = 0;
            Ld = 0; 
            Rdy = 0;
        end

        update: begin
            if (sc == 16) begin
                next_state = done;
            end else begin
                next_state = shift;
            end
            Su = 1;
            Sh = 0;
            Ld = 0;
            Rdy = 0;
        end

        done: begin
            next_state = done;  // until reset being activated
            Su = 0;
            Sh = 0;
            Ld = 0;
            Rdy = 1;
        end
        
    endcase
end
endmodule