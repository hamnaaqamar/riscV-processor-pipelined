`timescale 1ns/1ps

module datamemory(
    output reg [31:0] data_out,
    input [31:0] data_in,
    input [31:0] address,
    input MemWrite,
    input MemRead,
    input clk
);
    
    // 16KB memory as bytes
    reg [7:0] memory [0:16383];
    integer i;
    
    initial begin
        for (i = 0; i < 16384; i = i + 1) 
            memory[i] = 8'b0;
        
        // Initialize test data at BYTE addresses
        // Address 100: value 100
        memory[100] = 8'd100;
        memory[101] = 8'd0;
        memory[102] = 8'd0;
        memory[103] = 8'd0;
        
        // Address 104: value 200
        memory[104] = 8'd200;
        memory[105] = 8'd0;
        memory[106] = 8'd0;
        memory[107] = 8'd0;
        
        // Array at byte addresses 200, 204, 208, 212
        memory[200] = 8'd5;
        memory[201] = 8'd0;
        memory[202] = 8'd0;
        memory[203] = 8'd0;
        
        memory[204] = 8'd6;
        memory[205] = 8'd0;
        memory[206] = 8'd0;
        memory[207] = 8'd0;
        
        memory[208] = 8'd7;
        memory[209] = 8'd0;
        memory[210] = 8'd0;
        memory[211] = 8'd0;
        
        memory[212] = 8'd8;
        memory[213] = 8'd0;
        memory[214] = 8'd0;
        memory[215] = 8'd0;
        
        $display("Data Memory initialized with BYTE addressing");
        $display("  Byte address 100 = 100");
        $display("  Byte address 104 = 200");
        $display("  Byte address 200 = 5");
        $display("  Byte address 204 = 6");
        $display("  Byte address 208 = 7");
        $display("  Byte address 212 = 8");
    end
    
    // Write 4 bytes on store word
    always @ (posedge clk) begin
        if (MemWrite) begin
            memory[address]     <= data_in[7:0];
            memory[address + 1] <= data_in[15:8];
            memory[address + 2] <= data_in[23:16];
            memory[address + 3] <= data_in[31:24];
            $display(">>> MEM WRITE: addr=%0d, data=%0d", address, data_in);
        end
    end
    
    // Read 4 bytes on load word
    always @ (*) begin
        if (MemRead) begin
            data_out = {memory[address + 3], memory[address + 2], 
                       memory[address + 1], memory[address]};
            if (data_out != 0)
                $display(">>> MEM READ: addr=%0d, data=%0d", address, data_out);
        end else begin
            data_out = 32'b0;
        end
    end
    
endmodule