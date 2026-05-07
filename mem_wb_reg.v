module mem_wb_reg (
    input clk, reset,
    // Control Signals
    input RegWrite_in, MemtoReg_in,
    // Data
    input [31:0] mem_data_in,
    input [31:0] alu_result_in,
    input [4:0]  rd_addr_in,

    // Outputs to WB stage
    output reg RegWrite_out, MemtoReg_out,
    output reg [31:0] mem_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0]  rd_addr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            {RegWrite_out, MemtoReg_out} <= 0;
            {mem_data_out, alu_result_out, rd_addr_out} <= 0;
        end else begin
            RegWrite_out   <= RegWrite_in;
            MemtoReg_out   <= MemtoReg_in;
            mem_data_out   <= mem_data_in;
            alu_result_out <= alu_result_in;
            rd_addr_out    <= rd_addr_in;
        end
    end
endmodule