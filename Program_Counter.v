// --- File: Program_Counter.v ---
module Program_Counter(
    input        clk,
    input        rst_n,
    input [31:0] pc_next,
    output reg [31:0] pc
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) pc <= 0;
        else pc <= pc_next;
    end
endmodule
