module IMEM (
    input  [31:0] addr,
    output [31:0] Instruction
);

    // ============================
    // 1. Memory Declaration
    // ============================
    reg [31:0] memory [0:255];  // 256 words of 32-bit instruction memory

    // ============================
    // 2. Memory Initialization
    // ============================
    initial begin
        // Ưu tiên load file imem2.hex trước, nếu không có thì load imem.hex
        if ($fopen("./mem/imem2.hex", "r"))
            $readmemh("./mem/imem2.hex", memory);
        else if ($fopen("./mem/imem.hex", "r"))
            $readmemh("./mem/imem.hex", memory);
    end

    // ============================
    // 3. Instruction Output Logic
    // ============================
    // Trả về lệnh halt (32'h00000063) nếu truy cập vượt quá 128 lệnh (dành cho SC1)
    // Vẫn giữ đủ 256 dòng cho SC2
    assign Instruction = (addr[11:2] < 128) ? memory[addr[11:2]] : 32'h00000063; // halt = beq x0, x0, 0

endmodule