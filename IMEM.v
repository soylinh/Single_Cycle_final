// --- File: IMEM.v ---
module IMEM(
    input  [31:0] address,
    output [31:0] instruction
);
    reg [31:0] memory [0:127]; // 128 dòng = 128 words

    assign instruction = memory[address[11:2]];

    initial $readmemh("./mem/imem.hex", memory);
endmodule
