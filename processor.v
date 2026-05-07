module processor (
    input clk,
    input reset
);

    // --- 1. IF Stage ---
    wire [31:0] IF_pc_next, IF_pc_current, IF_pc_plus4, IF_instr;
    wire [31:0] MEM_pc_branch; 
    wire        PCSrc;         

    pc_mux PC_MUX (
        .pc_plus_4(IF_pc_plus4), 
        .branch_target(MEM_pc_branch), 
        .pc_src(PCSrc), 
        .pc_next(IF_pc_next)
    );

    pc PC_REG (
        .clk(clk), .reset(reset), 
        .pc_in(IF_pc_next), 
        .pc_out(IF_pc_current)
    );

    instruction_memory IMEM (
        .address(IF_pc_current), 
        .instruction(IF_instr)
    );

    // FIXED: Matched to your adder4(sum, a, b)
    adder4 IF_ADDER (
        .a(IF_pc_current), 
        .b(4'd4),          // Constant 4-bit value
        .sum(IF_pc_plus4)
    );

    wire [31:0] ID_pc, ID_instr;
    if_id_reg IF_ID (
        .clk(clk), .reset(reset),
        .pc_in(IF_pc_current), .inst_in(IF_instr),
        .pc_out(ID_pc), .inst_out(ID_instr)
    );

    // --- 2. ID Stage ---
    wire [31:0] ID_rd1, ID_rd2, ID_imm;
    wire ID_Branch, ID_MemRead, ID_MemtoReg, ID_MemWrite, ID_ALUSrc, ID_RegWrite;
    wire [1:0] ID_ALUOp;
    wire [31:0] WB_reg_write_data;
    wire [4:0]  WB_rd_addr;
    wire        WB_RegWrite;

    controlunit CU (
        .opcode(ID_instr[6:0]), .Branch(ID_Branch), .MemRead(ID_MemRead),
        .MemtoReg(ID_MemtoReg), .ALUOp(ID_ALUOp), .MemWrite(ID_MemWrite),
        .ALUSrc(ID_ALUSrc), .RegWrite(ID_RegWrite)
    );

    regfile RF (
        .clk(clk), .reset(reset),
        .read_reg1(ID_instr[19:15]), .read_reg2(ID_instr[24:20]),
        .write_reg(WB_rd_addr), .write_data(WB_reg_write_data),
        .RegWrite(WB_RegWrite), .read_data1(ID_rd1), .read_data2(ID_rd2)
    );

    imm_gen IG (
        .instruction(ID_instr), 
        .immediate_output(ID_imm) 
    );

    wire EX_Branch, EX_MemRead, EX_MemtoReg, EX_MemWrite, EX_ALUSrc, EX_RegWrite;
    wire [1:0]  EX_ALUOp;
    wire [31:0] EX_pc, EX_rd1, EX_rd2, EX_imm;
    wire [4:0]  EX_rd_addr;
    wire [2:0]  EX_funct3;
    wire [6:0]  EX_funct7;

    id_ex_reg ID_EX (
        .clk(clk), .reset(reset),
        .RegWrite_in(ID_RegWrite), .MemtoReg_in(ID_MemtoReg), .MemRead_in(ID_MemRead),
        .MemWrite_in(ID_MemWrite), .Branch_in(ID_Branch), .ALUSrc_in(ID_ALUSrc),
        .ALUOp_in(ID_ALUOp), .pc_in(ID_pc), .rd1_in(ID_rd1), .rd2_in(ID_rd2),
        .imm_in(ID_imm), .rd_addr_in(ID_instr[11:7]),
        .funct3_in(ID_instr[14:12]), .funct7_in(ID_instr[31:25]),
        .RegWrite_out(EX_RegWrite), .MemtoReg_out(EX_MemtoReg), .MemRead_out(EX_MemRead),
        .MemWrite_out(EX_MemWrite), .Branch_out(EX_Branch), .ALUSrc_out(EX_ALUSrc),
        .ALUOp_out(EX_ALUOp), .pc_out(EX_pc), .rd1_out(EX_rd1), .rd2_out(EX_rd2),
        .imm_out(EX_imm), .rd_addr_out(EX_rd_addr),
        .funct3_out(EX_funct3), .funct7_out(EX_funct7)
    );

    // --- 3. EX Stage ---
    wire [31:0] EX_alu_src2, EX_alu_result, EX_branch_pc;
    wire [3:0]  EX_alu_ctrl;
    wire        EX_alu_zero;

    alu_src_mux ALUMUX (
        .read_data2(EX_rd2), .imm(EX_imm), .ALUSrc(EX_ALUSrc), .alu_src(EX_alu_src2)
    );

    alu_control ALUC (
        .ALUOp(EX_ALUOp), .funct7(EX_funct7), .funct3(EX_funct3), .ALUControl(EX_alu_ctrl)
    );

    alu ALU_UNIT (
        .A(EX_rd1), .B(EX_alu_src2), .ALUControl(EX_alu_ctrl),
        .Result(EX_alu_result), .Zero(EX_alu_zero)
    );

    branch_adder BADD (
        .pc(EX_pc), .immediate(EX_imm), .branch_address(EX_branch_pc)
    );

    wire MEM_Branch, MEM_MemRead, MEM_MemtoReg, MEM_MemWrite, MEM_RegWrite, MEM_alu_zero;
    wire [31:0] MEM_alu_result, MEM_rd2_data;
    wire [4:0]  MEM_rd_addr;

    ex_mem_reg EX_MEM (
        .clk(clk), .reset(reset),
        .RegWrite_in(EX_RegWrite), .MemtoReg_in(EX_MemtoReg), .MemRead_in(EX_MemRead),
        .MemWrite_in(EX_MemWrite), .Branch_in(EX_Branch),
        .branch_pc_in(EX_branch_pc), .alu_zero_in(EX_alu_zero),
        .alu_result_in(EX_alu_result), .rd2_data_in(EX_rd2), .rd_addr_in(EX_rd_addr),
        .RegWrite_out(MEM_RegWrite), .MemtoReg_out(MEM_MemtoReg), .MemRead_out(MEM_MemRead),
        .MemWrite_out(MEM_MemWrite), .Branch_out(MEM_Branch),
        .branch_pc_out(MEM_pc_branch), .alu_zero_out(MEM_alu_zero),
        .alu_result_out(MEM_alu_result), .rd2_data_out(MEM_rd2_data), .rd_addr_out(MEM_rd_addr)
    );

    // --- 4. MEM Stage ---
    wire [31:0] MEM_read_data;
    assign PCSrc = MEM_Branch & MEM_alu_zero;

    datamemory DMEM (
        .clk(clk), 
        .MemRead(MEM_MemRead), 
        .MemWrite(MEM_MemWrite),
        .address(MEM_alu_result), 
        .data_in(MEM_rd2_data),   
        .data_out(MEM_read_data)  
    );

    wire WB_MemtoReg;
    wire [31:0] WB_mem_data, WB_alu_result;

    mem_wb_reg MEM_WB (
        .clk(clk), .reset(reset),
        .RegWrite_in(MEM_RegWrite), .MemtoReg_in(MEM_MemtoReg),
        .mem_data_in(MEM_read_data), .alu_result_in(MEM_alu_result), .rd_addr_in(MEM_rd_addr),
        .RegWrite_out(WB_RegWrite), .MemtoReg_out(WB_MemtoReg),
        .mem_data_out(WB_mem_data), .alu_result_out(WB_alu_result), .rd_addr_out(WB_rd_addr)
    );

    // --- 5. WB Stage ---
    writeback_mux WBMUX (
        .alu_result(WB_alu_result), .read_data(WB_mem_data), 
        .MemtoReg(WB_MemtoReg), .write_data(WB_reg_write_data)
    );

endmodule