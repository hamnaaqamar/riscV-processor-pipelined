module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);
    reg [7:0] memory [0:1023];

    initial begin
        // --- TEST CASE 1: R-TYPE DATA HAZARD ---
        // 0: add x5, x9, x10   (x5 = x9 + x10)
        {memory[3], memory[2], memory[1], memory[0]} = 32'h00a482b3;
        
        // 4: sub x6, x5, x11   (Uses x5 immediately! Requires Forwarding)
        {memory[7], memory[6], memory[5], memory[4]} = 32'h40b28333;

        // --- TEST CASE 2: LOAD-USE HAZARD ---
        // 8: sw x6, 8(x0)      (Store x6 to address 8)
        {memory[11], memory[10], memory[9], memory[8]} = 32'h00602423;
        
        // 12: lw x7, 8(x0)     (Load from address 8 to x7)
        {memory[15], memory[14], memory[13], memory[12]} = 32'h00802383;

        // 16: add x8, x7, x5   (Uses x7 immediately! Requires Stalling + Forwarding)
        {memory[19], memory[18], memory[17], memory[16]} = 32'h00538433;

        // --- TEST CASE 3: BRANCH HAZARD ---
        // 20: beq x7, x6, -12  (If x7 == x6, jump back to address 8)
        // Offset is -12 bytes: 20 -> 8.
        {memory[23], memory[22], memory[21], memory[20]} = 32'hf66386e3;
    end

    assign instruction = (address < 1024) ? {memory[address+3], memory[address+2], memory[address+1], memory[address+0]} : 32'h0;
endmodule