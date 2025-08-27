module mealy_fsm
(
    input clk,
    input a,
	 input b,
    input rst, // Choose to have it, the given testbench need to be revised
    output reg unlock
);


// State declaration
localparam S0 = 4'b0000;
localparam S1 = 4'b0001;
localparam S2 = 4'b0010;
localparam S3 = 4'b0011;
localparam S4 = 4'b0100;
localparam S5 = 4'b0101;
localparam S6 = 4'b0110;
localparam S7 = 4'b0111;
// Add one more state to include the case after flip a-b-a-a,
// and switches goes from 10 to 00 to 10
localparam S8 = 4'b1000; 
// register to store the state
// 9 states need 4-bit register
reg [3:0] curr_state;
reg [3:0] next_state;

// If reset not being pressed, the register will be
// updated in each clk cycle; else, state returns to S0
always @(posedge clk or posedge rst) begin
    if (rst) begin
        curr_state <= S0;
    end else begin
        curr_state <= next_state;
    end
end

// Combinational logic - Given the present state and current input,
// generate the next state and the current output.
always @(*) begin
    
    case(curr_state)

    S0: begin
        unlock = 0;
        if ({a,b} == 2'b10) begin
            next_state = S1;
        end else begin
            next_state = S0;
        end
    end

    S1: begin
        unlock = 0;
        if (({a,b} == 2'b01) || ({a,b} == 2'b11) ) begin
            next_state = S0;
        end else if ({a,b} == 2'b10) begin
            next_state = S1;
        end else begin
            next_state = S2;
        end
    end

    S2: begin
        unlock = 0;
        if ({a,b} == 2'b00) begin
            next_state = S2;
        end else if ({a,b} == 2'b01) begin
            next_state = S3;
        end else if ({a,b} == 2'b10) begin
            next_state = S1;
        end else begin
            next_state = S0;
        end
    end

    S3: begin
        unlock = 0; 
        if ({a,b} == 2'b00) begin
            next_state = S4;
        end else if ({a,b} == 2'b01) begin
            next_state = S3;
        end else begin
            next_state = S0;
        end
    end

    S4: begin
        unlock = 0;
        if ({a,b} == 2'b00) begin
            next_state = S4;
        end else if ({a,b} == 2'b01) begin
            next_state = S0;
        end else if ({a,b} == 2'b10) begin
            next_state = S5;
        end else begin
            next_state = S0;
        end
    end

    S5: begin
        unlock = 0;
        if ({a,b} == 2'b00) begin
            next_state = S6;
        end else if ({a,b} == 2'b01) begin
            next_state = S0;
        end else if ({a,b} == 2'b10) begin
            next_state = S5;
        end else begin
            next_state = S0;
        end
    end

    S6: begin
        if ({a,b} == 2'b00) begin
            next_state = S6;
            unlock = 0;
        end else if ({a,b} == 2'b01) begin
            next_state = S0;
            unlock = 0; 
        end else if ({a,b} == 2'b10) begin
            next_state = S7;
            unlock = 1;
        end else begin
            next_state = S0;
            unlock = 0; 
        end
    end

    S7: begin
        if ({a,b} == 2'b00) begin
            next_state = S8;
            unlock = 1;
        end else if ({a,b} == 2'b01) begin
            next_state = S0;
            unlock = 0; 
        end else if ({a,b} == 2'b10) begin
            next_state = S7;
            unlock = 1;
        end else begin
            next_state = S0;
            unlock = 0;
        end
    end

     S8: begin
        if ({a,b} == 2'b00) begin
            next_state = S8;
            unlock = 1;
        end else if ({a,b} == 2'b01) begin
            next_state = S0;
            unlock = 0; 
        end else if ({a,b} == 2'b10) begin
            next_state = S0;
            unlock = 0;
        end else begin
            next_state = S0;
            unlock = 0;
        end
    end
    
    endcase

end
endmodule