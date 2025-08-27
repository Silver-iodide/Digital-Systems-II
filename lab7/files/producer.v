module producer
#(parameter M=6, parameter K=4)
(
    input write_clk,
    input full, 
    input rst,
    output reg [K-1:0] data_out,
    output reg write
);

// Registers
reg [K-1:0] ram [M-1:0] /* synthesis ramstyle = "M9K" */;
reg [M-1:0] curr_A;     // current internal memory address
reg [M-1:0] next_A;

integer i;

// Initialize the RAM value
initial begin
    for (i = 0; i < M; i = i+1) begin
        ram[i] = i;
    end
end

// Sequential logic for data transaction
always @(posedge write_clk or posedge rst) begin
    if (rst) begin
        curr_A <= 0;
        data_out <= ram[curr_A];
    end 
    
    else begin

        if (!full) begin
            data_out <= ram[curr_A];
            write <= 1;  
            // update A address
            if (curr_A == (M-1)) begin
                curr_A <= 0;
            end else begin
                curr_A <= curr_A + 1;
            end
        end 
        
        else begin
            write <= 0; 
            data_out <= ram[curr_A];    // keep data_out in a correct value
        end

    end
end

// always @ (*) begin
//     if (!full) begin
//         data_out = ram[curr_A]; 
//         write = 1; 
//         // Next_A logic
//         if (curr_A == (M-1)) begin
//             next_A = 0;
//         end else begin
//             next_A = curr_A + 1; 
//         end
//     end

//     else begin
//         write = 0;
//         data_out = ram[curr_A];
//     end

// end

// always @ (posedge write_clk or posedge rst) begin
//     if (rst) begin
//         curr_A <= 0;
//         data_out <= ram[curr_A]; 
//     end else begin
//         curr_A <= next_A;
//     end
// end



endmodule