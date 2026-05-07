module if_id_reg (
    input clk, reset,
    input [31:0] pc_in, inst_in,
    output reg [31:0] pc_out, inst_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 0; inst_out <= 0;
        end else begin
            pc_out <= pc_in; inst_out <= inst_in;
        end
    end
endmodule