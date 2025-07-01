// --- File: DMEM.v ---
module DMEM(
    input         clk,
    input  [31:0] address,
    input  [31:0] write_data,
    input         MemRW,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:127]; // 128 dòng

    always @(*) begin
        read_data = memory[address[11:2]];
    end

    always @(posedge clk) begin
        if (MemRW) begin
            memory[address[11:2]] <= write_data;
        end
    end

    initial $readmemh("./mem/dmem_init.hex", memory);
endmodule
