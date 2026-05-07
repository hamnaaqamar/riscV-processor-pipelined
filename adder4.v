`timescale 1ns/1ps

module adder4(sum, a, b);
input [31:0] a;
input [3:0] b;
output reg [31:0] sum;

always @ (*)
begin
    sum <= a + b;
end
endmodule