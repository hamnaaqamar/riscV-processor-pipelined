`timescale 1ns/1ps

module pc(
    input clk,
    input reset,
    input stall,      // Added stall input
    input [31:0] pc_in,
    output reg [31:0] pc_out
);

always @(posedge clk) begin
    if (reset)
        pc_out <= 32'b0;
    else if (!stall)  // Only update if NOT stalling
        pc_out <= pc_in;
end

endmodule