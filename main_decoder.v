// --- File: main_decoder.v ---
module main_decoder(
    input  [6:0] opcode,
    output Branch, MemRW, MemtoReg, ALUSrc, RegWrite,
    output [1:0] ALUOp
);
    wire branch, memrw, memtoreg, alusrc, regwrite;
    wire [1:0] aluop;
    control_unit cu(
        .opcode(opcode),
        .Branch(branch),
        .MemRW(memrw),
        .MemtoReg(memtoreg),
        .ALUOp(aluop),
        .ALUSrc(alusrc),
        .RegWrite(regwrite)
    );
    assign Branch = branch;
    assign MemRW = memrw;
    assign MemtoReg = memtoreg;
    assign ALUSrc = alusrc;
    assign RegWrite = regwrite;
    assign ALUOp = aluop;
endmodule
