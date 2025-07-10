module ALU (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  ALUOp,
    output logic [31:0] Result,
    output logic Zero
);

    // ============================
    // 1. ALU Operation Constants
    // ============================
    // ALU Control Codes (must match ALU_decoder.v and control_unit.v)
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

    // ============================
    // 2. ALU Operation Logic
    // ============================
    always @(*) begin
        case (ALUOp)
            // Arithmetic Operations
            ALU_ADD:  Result = A + B;                                    // Addition
            ALU_SUB:  Result = A - B;                                    // Subtraction

            // Logical Operations
            ALU_AND:  Result = A & B;                                    // Bitwise AND
            ALU_OR:   Result = A | B;                                    // Bitwise OR
            ALU_XOR:  Result = A ^ B;                                    // Bitwise XOR

            // Shift Operations
            ALU_SLL:  Result = A << B[4:0];                              // Shift Left Logical
            ALU_SRL:  Result = A >> B[4:0];                              // Shift Right Logical
            ALU_SRA:  Result = $signed(A) >>> B[4:0];                    // Shift Right Arithmetic

            // Comparison Operations
            ALU_SLT:  Result = ($signed(A) < $signed(B)) ? 32'h1 : 32'h0; // Set Less Than (signed)
            ALU_SLTU: Result = (A < B) ? 32'h1 : 32'h0;                   // Set Less Than Unsigned

            // Default case
            default:  Result = 32'b0;
        endcase
    end

    // ============================
    // 3. Zero Flag Generation
    // ============================
    // Zero flag is set when ALU result is zero (used for branch conditions)
    assign Zero = (Result == 32'b0);

endmodule