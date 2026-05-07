`timescale 1ns/1ps
module alu_src_mux(
    input [31:0] read_data2,
    input [31:0] imm,
    input ALUSrc,
    output reg [31:0] alu_src
);

always @(*) begin
    alu_src = (ALUSrc) ? imm : read_data2;
end
endmodule