// --- File: control_unit.v ---
module control_unit(
    input  [6:0] opcode,
    output reg Branch,
    output reg MemRW,
    output reg MemtoReg,
    output reg [1:0] ALUOp,
    output reg ALUSrc,
    output reg RegWrite
);
    always @(*) begin
        // Default values
        Branch = 0; MemRW = 0; MemtoReg = 0;
        ALUOp = 2'b00; ALUSrc = 0; RegWrite = 0;
        case(opcode)
            7'b0110011: begin // R-type
                RegWrite = 1; ALUOp = 2'b10;
            end
            7'b0000011: begin // LW
                RegWrite = 1; ALUSrc = 1; MemtoReg = 1;
            end
            7'b0100011: begin // SW
                ALUSrc = 1; MemRW = 1;
            end
            7'b1100011: begin // BEQ
                Branch = 1; ALUOp = 2'b01;
            end
            7'b0010011: begin // I-type (ADDI)
                RegWrite = 1; ALUSrc = 1; ALUOp = 2'b10;
            end
        endcase
    end
endmodule
