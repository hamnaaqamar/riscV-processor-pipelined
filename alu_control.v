`timescale 1ns/1ps
module alu_control(
    input [1:0] ALUOp,
    input [6:0] funct7,
    input [2:0] funct3,

    output reg [3:0] ALUControl
);

always @(*) begin

    case(ALUOp)

        2'b00: ALUControl = 4'b0010; // LW/SW = ADD

        2'b01: ALUControl = 4'b0110; // BEQ = SUB

        2'b10: begin

            case({funct7, funct3})

                {7'b0000000,3'b000}:
                    ALUControl = 4'b0010; // ADD

                {7'b0100000,3'b000}:
                    ALUControl = 4'b0110; // SUB

                {7'b0000000,3'b111}:
                    ALUControl = 4'b0000; // AND

                {7'b0000000,3'b110}:
                    ALUControl = 4'b0001; // OR

                default:
                    ALUControl = 4'b0000;

            endcase

        end

        default:
            ALUControl = 4'b0000;

    endcase

end

endmodule