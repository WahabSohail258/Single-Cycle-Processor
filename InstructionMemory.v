module ROM(
    input [31:0] address,
    output reg [31:0] instruction
);

reg [31:0] memory [0:31];

initial begin
    memory[0] = 32'b101010_00001_00010_0000_0000_0000_0001;
    // Initialize other memory locations as needed
end

always @(address) begin
    instruction = memory[address];
end

endmodule
