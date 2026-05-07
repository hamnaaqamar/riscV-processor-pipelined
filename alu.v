module alu(
    input  [31:0] A,
    input  [31:0] B,
    input  [3:0] ALUControl,
    
    output reg [31:0] Result,
    output Zero
);

always @(*) begin

    case(ALUControl)

        4'b0000: begin
            // AND
            Result = A & B;
        end

        4'b0001: begin
            // OR
            Result = A | B;
        end

        4'b0010: begin
            // ADD
            Result = A + B;
        end

        4'b0110: begin
            // SUBTRACT
            Result = A - B;
        end

        default: begin
            Result = 32'b0;
        end

    endcase

end

// Zero flag used for BEQ
assign Zero = (Result == 32'b0);

endmodule