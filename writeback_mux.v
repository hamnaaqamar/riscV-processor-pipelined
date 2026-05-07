`timescale 1ns/1ps
module writeback_mux(
    input [31:0] alu_result,
    input [31:0] read_data,
    input MemtoReg,
    output reg [31:0] write_data
);

always @(*) begin
    write_data = (MemtoReg) ? read_data : alu_result;
end
endmodule