// --- File: ALU.v ---
module ALU(
    input  [31:0] a,
    input  [31:0] b,
    input  [3:0] alu_control,
    output reg [31:0] alu_result,
    output zero
);
    always @(*) begin
        case (alu_control)
            4'b0000: alu_result = a & b;        // AND
            4'b0001: alu_result = a | b;        // OR
            4'b0010: alu_result = a + b;        // ADD
            4'b0110: alu_result = a - b;        // SUB
            4'b0111: alu_result = (a < b) ? 1 : 0; // SLT
            4'b1100: alu_result = ~(a | b);     // NOR
            default: alu_result = 0;
        endcase
    end
    assign zero = (alu_result == 0);
endmodule
