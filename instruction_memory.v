module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);
    reg [7:0] memory [0:1023]; // Increased size

    initial begin
        // --- TEST CASE: R-TYPE ---
        // 0: add x5, x9, x10  (00a482b3)
        {memory[3], memory[2], memory[1], memory[0]} = 32'h00a482b3;
        // 4-12: THREE NOPs (addi x0, x0, 0) to wait for x5 to write back
        {memory[7], memory[6], memory[5], memory[4]} = 32'h00000013;
        {memory[11], memory[10], memory[9], memory[8]} = 32'h00000013;
        {memory[15], memory[14], memory[13], memory[12]} = 32'h00000013;

        // 16: sub x6, x5, x11 (40b28333)
        {memory[19], memory[18], memory[17], memory[16]} = 32'h40b28333;
        // 20-28: THREE NOPs
        {memory[23], memory[22], memory[21], memory[20]} = 32'h00000013;
        {memory[27], memory[26], memory[25], memory[24]} = 32'h00000013;
        {memory[31], memory[30], memory[29], memory[28]} = 32'h00000013;

        // --- TEST CASE: MEMORY ---
        // 32: sw x6, 8(x0)     (00602423) -> Store x6 into address 8
        {memory[35], memory[34], memory[33], memory[32]} = 32'h00602423;
        // 36-44: THREE NOPs
        {memory[39], memory[38], memory[37], memory[36]} = 32'h00000013;
        {memory[43], memory[42], memory[41], memory[40]} = 32'h00000013;
        {memory[47], memory[46], memory[45], memory[44]} = 32'h00000013;

        // 48: lw x7, 8(x0)     (00802383) -> Load back into x7
        {memory[51], memory[50], memory[49], memory[48]} = 32'h00802383;
        // 52-60: THREE NOPs
        {memory[55], memory[54], memory[53], memory[52]} = 32'h00000013;
        {memory[59], memory[58], memory[57], memory[56]} = 32'h00000013;
        {memory[63], memory[62], memory[61], memory[60]} = 32'h00000013;

        // --- TEST CASE: BRANCH ---
        // 64: beq x7, x6, -16  (fe6388e3) -> If x7==x6, jump back to sw (loop)
        {memory[67], memory[66], memory[65], memory[64]} = 32'hfe6388e3;
    end

    assign instruction = {memory[address+3], memory[address+2], memory[address+1], memory[address+0]};
endmodule