// --- File: RISCV_Single_Cycle.v ---
module RISCV_Single_Cycle(
    input clk,
    input rst_n,
    output [31:0] PC_out_top,
    output [31:0] Instruction_out_top
);

    wire [31:0] pc, pc_next, instr, imm, regdata1, regdata2, alu_b, alu_result, mem_read;
    wire [3:0] alu_control;
    wire zero, branch, memrw, memtoreg, alusrc, regwrite;
    wire [1:0] aluop;

    // --- PC
    Program_Counter PC_inst(
        .clk(clk),
        .rst_n(rst_n),
        .pc_next(pc_next),
        .pc(pc)
    );
    assign PC_out_top = pc; // Output cho testbench

    // --- IMEM
    IMEM IMEM_inst(
        .address(pc),
        .instruction(instr)
    );
    assign Instruction_out_top = instr; // Output cho testbench

    // --- Decode
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire funct7b5 = instr[30];
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];
    wire [4:0] rd  = instr[11:7];

    // --- Main Decoder
    main_decoder md(
        .opcode(opcode),
        .Branch(branch),
        .MemRW(memrw),
        .MemtoReg(memtoreg),
        .ALUSrc(alusrc),
        .RegWrite(regwrite),
        .ALUOp(aluop)
    );

    // --- Immediate Generator
    Imm_Gen immgen(
        .instr(instr),
        .imm_out(imm)
    );

    // --- Register File
    RegisterFile Reg_inst(
        .clk(clk),
        .regwrite(regwrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .writedata(memtoreg ? mem_read : alu_result),
        .readdata1(regdata1),
        .readdata2(regdata2)
    );

    // --- ALU Decoder
    ALU_decoder alu_dec(
        .alu_op(aluop),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .alu_control(alu_control)
    );

    // --- ALU
    assign alu_b = alusrc ? imm : regdata2;
    ALU alu(
        .a(regdata1),
        .b(alu_b),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );

    // --- Branch Comparator
    Branch_Comp bc(
        .a(regdata1),
        .b(regdata2),
        .eq(zero)
    );

    // --- DMEM
    DMEM DMEM_inst(
        .clk(clk),
        .address(alu_result),
        .write_data(regdata2),
        .MemRW(memrw),
        .read_data(mem_read)
    );

    // --- Next PC
    assign pc_next = (branch && zero) ? (pc + imm) : (pc + 4);

endmodule
