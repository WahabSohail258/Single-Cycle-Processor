module Splitter(
    input [31:0] instruction,
    output reg [6:0] opcode,
    output reg [15:0] offset,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [4:0] shamt,
    output reg [5:0] funct,
    output reg [25:0] imme
);

always @(instruction) begin
    opcode <= {1'b0, instruction[31:26]};
    offset <= instruction[15:0];
    rs1 <= instruction[25:21];
    rs2 <= instruction[20:16];
    rd <= instruction[15:11];
    shamt <= instruction[10:6];
    funct <= instruction[5:0];
    imme <= instruction[25:0];
end

endmodule
