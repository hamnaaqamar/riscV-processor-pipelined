module id_ex_reg (
    input clk, reset,
    // Control Signals (from ID stage)
    input RegWrite_in, MemtoReg_in, MemRead_in, MemWrite_in, Branch_in, ALUSrc_in,
    input [1:0] ALUOp_in,
    // Data (from ID stage)
    input [31:0] pc_in, rd1_in, rd2_in, imm_in,
    input [4:0]  rs1_in, rs2_in, rd_addr_in,
    input [2:0]  funct3_in,
    input [6:0]  funct7_in,

    // Outputs to EX stage
    output reg RegWrite_out, MemtoReg_out, MemRead_out, MemWrite_out, Branch_out, ALUSrc_out,
    output reg [1:0] ALUOp_out,
    output reg [31:0] pc_out, rd1_out, rd2_out, imm_out,
    output reg [4:0]  rs1_out, rs2_out, rd_addr_out,
    output reg [2:0]  funct3_out,
    output reg [6:0]  funct7_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            {RegWrite_out, MemtoReg_out, MemRead_out, MemWrite_out, Branch_out, ALUSrc_out, ALUOp_out} <= 0;
            {pc_out, rd1_out, rd2_out, imm_out, rs1_out, rs2_out, rd_addr_out, funct3_out, funct7_out} <= 0;
        end else begin
            RegWrite_out <= RegWrite_in; MemtoReg_out <= MemtoReg_in;
            MemRead_out  <= MemRead_in;  MemWrite_out <= MemWrite_in;
            Branch_out   <= Branch_in;   ALUSrc_out   <= ALUSrc_in;
            ALUOp_out    <= ALUOp_in;    pc_out       <= pc_in;
            rd1_out      <= rd1_in;      rd2_out      <= rd2_in;
            imm_out      <= imm_in;      rd_addr_out  <= rd_addr_in;
            funct3_out   <= funct3_in;   funct7_out   <= funct7_in;
            rs1_out      <= rs1_in;      rs2_out      <= rs2_in;
        end
    end
endmodule