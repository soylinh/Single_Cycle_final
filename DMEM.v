module DMEM (
    input logic clk,
    input logic rst_n,
    input logic MemRead,
    input logic MemWrite,
    input logic [31:0] addr,
    input logic [31:0] WriteData,
    output logic [31:0] ReadData
);
    // Memory array declaration
    logic [31:0] memory [0:255];

    // Initialize memory from hex file
    initial begin
        // Initialize all memory to 0 first
        for (int i = 0; i < 256; i = i + 1)
            memory[i] = 32'b0;

        // Then load from hex file if available
        if ($fopen("./mem/dmem_init2.hex", "r"))
            $readmemh("./mem/dmem_init2.hex", memory);
        else if ($fopen("./mem/dmem_init.hex", "r"))
            $readmemh("./mem/dmem_init.hex", memory);
    end

    // Sequential logic for write operations only (reset handled in initial)
    always_ff @(posedge clk) begin
        if (MemWrite) begin
            memory[addr[9:2]] <= WriteData;
        end
    end

    // Combinational logic for read operations
    assign ReadData = (MemRead) ? memory[addr[9:2]] : 32'b0;

endmodule