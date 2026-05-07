`timescale 1ns/1ps

module regfile(
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    input clk,
    input reset,
    input RegWrite,
    output reg [31:0] read_data1, 
    output reg [31:0] read_data2
);
reg[31:0] registers [31:0];
integer i;

initial begin
    registers[0] = 32'd0;
      registers[1] = 32'd0;
      registers[2] =32'd0;
      registers[3] = 32'd0;
      registers[4] = 32'd0;
      registers[5] =32'd0;
      registers[6] = 32'd0;
      registers[7] = 32'd0;
      registers[8] = 32'd0;
      registers[9] =32'd0;
      registers[10] = 32'd0;
      registers[11] =32'd0;
      registers[12] = 32'd0;
      registers[13] = 32'd0;
      registers[14] = 32'd0;
      registers[15] = 32'd0;
      registers[16] = 32'd0;
      registers[17] = 32'd0;
      registers[18] =32'd0;
      registers[19] = 32'd0;
      registers[20] = 32'd0;
      registers[21] = 32'd0;
      registers[22] = 32'd0;
      registers[23] = 32'd0;
      registers[24] = 32'd0;
      registers[25] = 32'd0;
      registers[26] = 32'd0;
      registers[27] = 32'd0;
      registers[28] = 32'd0;
      registers[29] = 32'd0;
      registers[30] = 32'd0;
      registers[31] =32'd0;

end

always @(*)
begin
    if (reset == 1'b1)
    begin 
        read_data1 = 32'd0;
        read_data2 = 32'd0;
    end
    else
    begin
        read_data1 = registers[read_reg1];
        read_data2 = registers[read_reg2];
    end
end

always @(posedge clk)
begin
    if (RegWrite == 1)
    registers[write_reg] = write_data;
end
endmodule