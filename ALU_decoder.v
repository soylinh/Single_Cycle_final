module ALU_decoder(
    input  [1:0] alu_op,
    input  [2:0] funct3,
    input        funct7b5,
    output logic [3:0] alu_control
);

    // ============================
    // 1. ALU Operation Constants
    // ============================
    // ALU Control Codes (must match ALU.v)
    localparam ALU_ADD  = 4'b0000;  // Addition
    localparam ALU_SUB  = 4'b0001;  // Subtraction
    localparam ALU_AND  = 4'b0010;  // Bitwise AND
    localparam ALU_OR   = 4'b0011;  // Bitwise OR
    localparam ALU_XOR  = 4'b0100;  // Bitwise XOR
    localparam ALU_SLL  = 4'b0101;  // Shift Left Logical
    localparam ALU_SRL  = 4'b0110;  // Shift Right Logical
    localparam ALU_SRA  = 4'b0111;  // Shift Right Arithmetic
    localparam ALU_SLT  = 4'b1000;  // Set Less Than (signed)
    localparam ALU_SLTU = 4'b1001;  // Set Less Than Unsigned

    // ALU_OP Control Codes
    localparam ALUOP_LDSW   = 2'b00;  // Load/Store (ADD)
    localparam ALUOP_BRANCH = 2'b01;  // Branch (SUB for comparison)
    localparam ALUOP_RTYPE  = 2'b10;  // R-type/I-type arithmetic
    localparam ALUOP_UTYPE  = 2'b11;  // U-type (reserved for future use)

    // Function3 Codes for R-type/I-type instructions
    localparam FUNCT3_ADDSUB = 3'b000;  // ADD/SUB
    localparam FUNCT3_SLL    = 3'b001;  // Shift Left Logical
    localparam FUNCT3_SLT    = 3'b010;  // Set Less Than
    localparam FUNCT3_SLTU   = 3'b011;  // Set Less Than Unsigned
    localparam FUNCT3_XOR    = 3'b100;  // XOR
    localparam FUNCT3_SRLSRA = 3'b101;  // Shift Right Logical/Arithmetic
    localparam FUNCT3_OR     = 3'b110;  // OR
    localparam FUNCT3_AND    = 3'b111;  // AND

    // ============================
    // 2. ALU Control Decode Logic
    // ============================
    always_comb begin
        // Default: ADD operation (for load/store)
        alu_control = ALU_ADD;

        case (alu_op)
            // Load/Store instructions: always ADD
            ALUOP_LDSW:
                alu_control = ALU_ADD;

            // Branch instructions: always SUB (for comparison)
            ALUOP_BRANCH:
                alu_control = ALU_SUB;

            // R-type/I-type arithmetic instructions
            ALUOP_RTYPE: begin
                case (funct3)
                    FUNCT3_ADDSUB: // ADD/SUB
                        alu_control = (funct7b5) ? ALU_SUB : ALU_ADD;

                    FUNCT3_SLL:    // Shift Left Logical
                        alu_control = ALU_SLL;

                    FUNCT3_SLT:    // Set Less Than (signed)
                        alu_control = ALU_SLT;

                    FUNCT3_SLTU:   // Set Less Than Unsigned
                        alu_control = ALU_SLTU;

                    FUNCT3_XOR:    // XOR
                        alu_control = ALU_XOR;

                    FUNCT3_SRLSRA: // Shift Right Logical/Arithmetic
                        alu_control = (funct7b5) ? ALU_SRA : ALU_SRL;

                    FUNCT3_OR:     // OR
                        alu_control = ALU_OR;

                    FUNCT3_AND:    // AND
                        alu_control = ALU_AND;

                    default:
                        alu_control = ALU_ADD;
                endcase
            end

            // U-type or other instructions: default to ADD
            default:
                alu_control = ALU_ADD;
        endcase
    end

endmodule