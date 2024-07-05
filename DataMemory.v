module data_memory(
    input [31:0] address,
    input [31:0] write_data,
    input sig_memread,
    input sig_memwrite,
    output reg [31:0] read_data
);

reg [31:0] memory [0:31];

initial begin
    memory[0]  = 0;   memory[1]  = 1;   memory[2]  = 2;   memory[3]  = 3;
    memory[4]  = 4;   memory[5]  = 5;   memory[6]  = 6;   memory[7]  = 7;
    memory[8]  = 8;   memory[9]  = 9;   memory[10] = 10;  memory[11] = 11;
    memory[12] = 12;  memory[13] = 13;  memory[14] = 14;  memory[15] = 15;
    memory[16] = 16;  memory[17] = 17;  memory[18] = 18;  memory[19] = 19;
    memory[20] = 20;  memory[21] = 21;  // Initialize as needed
end

always @(address) begin
    if (sig_memread)
        read_data <= memory[address];
end

always @(address) begin
    if (sig_memwrite)
        memory[address] <= write_data;
end

endmodule
