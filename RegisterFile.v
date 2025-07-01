// --- File: RegisterFile.v ---
module RegisterFile(
    input         clk,
    input         regwrite,
    input  [4:0]  rs1,
    input  [4:0]  rs2,
    input  [4:0]  rd,
    input  [31:0] writedata,
    output [31:0] readdata1,
    output [31:0] readdata2
);
    reg [31:0] registers [0:31];
    always @(posedge clk) begin
        if (regwrite && rd != 0)
            registers[rd] <= writedata;
    end
    assign readdata1 = (rs1 != 0) ? registers[rs1] : 0;
    assign readdata2 = (rs2 != 0) ? registers[rs2] : 0;
    integer i;
    initial for (i = 0; i < 32; i = i + 1) registers[i] = 0;
endmodule
