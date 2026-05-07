module forwarding_unit (
    input [4:0] EX_rs1, EX_rs2,
    input [4:0] MEM_rd, WB_rd,
    input MEM_RegWrite, WB_RegWrite,
    output reg [1:0] forwardA, forwardB
);
    always @(*) begin
        // Forward A logic (for rs1)
        if (MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs1)) 
            forwardA = 2'b10; // Forward from MEM stage
        else if (WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs1)) 
            forwardA = 2'b01; // Forward from WB stage
        else 
            forwardA = 2'b00; // No forwarding

        // Forward B logic (for rs2)
        if (MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs2)) 
            forwardB = 2'b10; // Forward from MEM stage
        else if (WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs2)) 
            forwardB = 2'b01; // Forward from WB stage
        else 
            forwardB = 2'b00; // No forwarding
    end
endmodule