module branch_adder(
    input  [31:0] pc,
    input  [31:0] immediate,
    output [31:0] branch_address
);

assign branch_address = pc + immediate;

endmodule