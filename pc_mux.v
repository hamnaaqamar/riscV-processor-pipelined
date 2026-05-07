`timescale 1ns/1ps
module pc_mux(
    input [31:0] pc_plus_4,
    input [31:0] branch_target,
    input pc_src,
    output reg [31:0] pc_next
);

always @(*) begin
    pc_next = (pc_src) ? branch_target : pc_plus_4;
end
endmodule