module Imm_Gen (
    input  logic [31:0] inst,
    output logic [31:0] imm_out
);

    // ============================
    // 1. Opcode Extraction
    // ============================
    wire [6:0] opcode = inst[6:0];

    // ============================
    // 2. Opcode Constants (for reference)
    // ============================
    // I-type instructions
    localparam LOAD_OP    = 7'b0000011;  // lw, lh, lb, lhu, lbu
    localparam IMM_OP     = 7'b0010011;  // addi, slti, sltiu, xori, ori, andi, slli, srli, srai
    localparam JALR_OP    = 7'b1100111;  // jalr

    // S-type instructions
    localparam STORE_OP   = 7'b0100011;  // sw, sh, sb

    // B-type instructions
    localparam BRANCH_OP  = 7'b1100011;  // beq, bne, blt, bge, bltu, bgeu

    // U-type instructions
    localparam AUIPC_OP   = 7'b0010111;  // auipc
    localparam LUI_OP     = 7'b0110111;  // lui

    // J-type instructions
    localparam JAL_OP     = 7'b1101111;  // jal

    // ============================
    // 3. Immediate Generation Logic
    // ============================
    always @(*) begin
        case (opcode)
            // I-type: 12-bit immediate, sign-extended
            LOAD_OP,    // Load instructions
            IMM_OP,     // Immediate arithmetic/logic instructions
            JALR_OP:    // Jump and link register
                imm_out = {{20{inst[31]}}, inst[31:20]};

            // S-type: 12-bit immediate, sign-extended
            STORE_OP:   // Store instructions
                imm_out = {{20{inst[31]}}, inst[31:25], inst[11:7]};

            // B-type: 13-bit immediate, sign-extended, LSB always 0
            BRANCH_OP:  // Branch instructions
                imm_out = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};

            // U-type: 20-bit immediate, upper 20 bits
            AUIPC_OP,   // Add upper immediate to PC
            LUI_OP:     // Load upper immediate
                imm_out = {inst[31:12], 12'b0};

            // J-type: 21-bit immediate, sign-extended, LSB always 0
            JAL_OP:     // Jump and link
                imm_out = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};

            // Default case: no immediate
            default:
                imm_out = 32'b0;
        endcase
    end

endmodule