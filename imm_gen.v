`timescale 1ns/1ps

module imm_gen(
    input[31:0] instruction,
    output reg [31:0] immediate_output
);

parameter [6:0] LOAD_OPCODE = 7'b0000011;
parameter [6:0] STORE_OPCODE = 7'b0100011;
parameter [6:0] BRANCH_OPCODE = 7'b1100011;
wire [6:0] opcode = instruction[6:0];
wire [11:0] load_im = instruction[31:20];
wire [11:0] store_im = {instruction[31:25],instruction[11:7]};
wire [12:1] branch_im = {instruction[31], instruction[7], instruction[30:25],
instruction[11:8]};
always @(*) begin
case(opcode)
LOAD_OPCODE: immediate_output = { {20{load_im[11]}} , load_im};
STORE_OPCODE: immediate_output = { {20{store_im[11]}} , store_im};
BRANCH_OPCODE: immediate_output = 2*{{20{branch_im[12]}} ,
branch_im}; // left shift
default: immediate_output = 32'b0;
endcase
end

endmodule