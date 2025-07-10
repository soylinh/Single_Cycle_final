module RISCV_Single_Cycle(
    input logic clk,
    input logic rst_n,
    output logic [31:0] PC_out_top,
    output logic [31:0] Instruction_out_top
);

    // ============================
    // FETCH STAGE
    // ============================

    // 1. Program Counter
    logic [31:0] PC_next;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            PC_out_top <= 32'b0;
        else
            PC_out_top <= PC_next;
    end

    // 2. Instruction Memory
    IMEM IMEM_inst(
        .addr(PC_out_top),
        .Instruction(Instruction_out_top)
    );

    // ============================
    // DECODE STAGE
    // ============================

    // 3. Decode Instruction Fields
    logic [4:0] rs1, rs2, rd;
    logic [2:0] funct3;
    logic [6:0] opcode, funct7;

    assign opcode = Instruction_out_top[6:0];
    assign rd     = Instruction_out_top[11:7];
    assign funct3 = Instruction_out_top[14:12];
    assign rs1    = Instruction_out_top[19:15];
    assign rs2    = Instruction_out_top[24:20];
    assign funct7 = Instruction_out_top[31:25];

    // 4. Control Unit
    logic [1:0] ALUSrc;  // Fixed: Match control_unit.v output width
    logic [3:0] ALUCtrl;
    logic Branch, MemRead, MemWrite, MemToReg;
    logic RegWrite, PCSel;

    control_unit ctrl(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUCtrl),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .RegWrite(RegWrite)
    );

    // 5. Immediate Generator
    logic [31:0] Imm;

    Imm_Gen imm_gen(
        .inst(Instruction_out_top),
        .imm_out(Imm)
    );

    // 6. Register File
    logic [31:0] ReadData1, ReadData2, WriteData;

    RegisterFile Reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // ============================
    // EXECUTE STAGE
    // ============================

    // 7. ALU Input Selection
    logic [31:0] ALU_in1, ALU_in2;

    // ALU Input 1: ReadData1 for most instructions, PC for AUIPC
    assign ALU_in1 = (ALUSrc[1]) ? PC_out_top : ReadData1;

    // ALU Input 2: Immediate for I/S/B/U/J types, ReadData2 for R-type
    assign ALU_in2 = (ALUSrc[0]) ? Imm : ReadData2;

    // 8. ALU
    logic [31:0] ALU_result;
    logic ALUZero;

    ALU alu(
        .A(ALU_in1),
        .B(ALU_in2),
        .ALUOp(ALUCtrl),
        .Result(ALU_result),
        .Zero(ALUZero)
    );

    // 9. Branch Comparator
    Branch_Comp comp(
        .A(ReadData1),
        .B(ReadData2),
        .Branch(Branch),
        .funct3(funct3),
        .BrTaken(PCSel)
    );

    // ============================
    // MEMORY STAGE
    // ============================

    // 10. Data Memory
    logic [31:0] MemReadData;

    DMEM DMEM_inst(
        .clk(clk),
        .rst_n(rst_n),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(ALU_result),
        .WriteData(ReadData2),
        .ReadData(MemReadData)
    );

    // ============================
    // WRITE-BACK STAGE
    // ============================

    // 11. Write-back Mux
    assign WriteData = (MemToReg) ? MemReadData : ALU_result;

    // ============================
    // PC UPDATE
    // ============================

    // 12. Next PC Logic
    assign PC_next = (PCSel) ? PC_out_top + Imm : PC_out_top + 4;

endmodule
