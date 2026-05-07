module controlunit(
    input  [6:0] opcode,     // Opcode from the instruction
    output reg   Branch,
    output reg   MemRead,
    output reg   MemtoReg,
    output reg [1:0] ALUOp,
    output reg   MemWrite,
    output reg   ALUSrc,
    output reg   RegWrite
);

    always @(*) begin
        // Default values (Safety first: everything off)
        ALUSrc   = 0; MemtoReg = 0; RegWrite = 0; 
        MemRead  = 0; MemWrite = 0; Branch   = 0; 
        ALUOp    = 2'b00;

        case (opcode)
            7'b0110011: begin // R-type (add, sub, and, or)
                RegWrite = 1;
                ALUOp    = 2'b10; // Use funct bits for ALU
            end
            7'b0000011: begin // lw (load word)
                ALUSrc   = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemRead  = 1;
                ALUOp    = 2'b00; // ALU performs addition
            end
            7'b0100011: begin // sw (store word)
                ALUSrc   = 1;
                MemWrite = 1;
                ALUOp    = 2'b00; // ALU performs addition
            end
            7'b1100011: begin // beq (branch if equal)
                Branch   = 1;
                ALUOp    = 2'b01; // ALU performs subtraction
            end
            default: begin
                // Handle unknown opcodes
            end
        endcase
    end
endmodule
