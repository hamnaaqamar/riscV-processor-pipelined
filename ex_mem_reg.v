module ex_mem_reg (
    input clk, reset,
    // Control Signals
    input RegWrite_in, MemtoReg_in, MemRead_in, MemWrite_in, Branch_in,
    // Data
    input [31:0] branch_pc_in,
    input        alu_zero_in,
    input [31:0] alu_result_in,
    input [31:0] rd2_data_in, // For Store instructions
    input [4:0]  rd_addr_in,

    // Outputs to MEM stage
    output reg RegWrite_out, MemtoReg_out, MemRead_out, MemWrite_out, Branch_out,
    output reg [31:0] branch_pc_out,
    output reg        alu_zero_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] rd2_data_out,
    output reg [4:0]  rd_addr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            {RegWrite_out, MemtoReg_out, MemRead_out, MemWrite_out, Branch_out} <= 0;
            {branch_pc_out, alu_zero_out, alu_result_out, rd2_data_out, rd_addr_out} <= 0;
        end else begin
            RegWrite_out <= RegWrite_in; MemtoReg_out <= MemtoReg_in;
            MemRead_out  <= MemRead_in;  MemWrite_out <= MemWrite_in;
            Branch_out   <= Branch_in;   branch_pc_out <= branch_pc_in;
            alu_zero_out <= alu_zero_in; alu_result_out <= alu_result_in;
            rd2_data_out <= rd2_data_in; rd_addr_out  <= rd_addr_in;
        end
    end
endmodule