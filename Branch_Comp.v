// --- File: Branch_Comp.v ---
module Branch_Comp(
    input  [31:0] a,
    input  [31:0] b,
    output        eq
);
    assign eq = (a == b);
endmodule
