module hazard_detection (
    input [4:0] ID_rs1, 
    input [4:0] ID_rs2,
    input [4:0] EX_rd,
    input EX_MemRead, // High only for Load instructions
    output reg stall
);
    always @(*) begin
        // If EX is a Load AND it's writing to a register we need in ID...
        if (EX_MemRead && (EX_rd != 0) && ((EX_rd == ID_rs1) || (EX_rd == ID_rs2)))
            stall = 1'b1;
        else
            stall = 1'b0;
    end
endmodule