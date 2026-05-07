module if_id_reg (
    input clk, reset, stall, flush,
    input [31:0] pc_in, inst_in,
    output reg [31:0] pc_out, inst_out
);
    always @(posedge clk) begin
        if (reset || flush) begin
            pc_out <= 0;
            inst_out <= 32'h00000013; // NOP
        end else if (!stall) begin
            pc_out <= pc_in;
            inst_out <= inst_in;
        end
    end
endmodule