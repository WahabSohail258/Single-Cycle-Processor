module ALU_32bit(
    input [3:0] opcode,
    input [31:0] a,
    input [31:0] b,
    input [4:0] shift,
    output reg [31:0] f,
    output reg zero_flag
);

parameter Add = 4'b0000, Sub = 4'b0001, Mul = 4'b0010, SLT = 4'b0011, Shift_left = 4'b0100, XORI = 4'b0110;

always @(*) begin
    case(opcode)
        Add: f <= a + b;
        Sub: f <= a - b;
        Mul: f <= a * b;
        SLT: f <= (a < b) ? 32'b1 : 32'b0;
        Shift_left: f <= a << shift;
        XORI: f <= a ^ b;
        default: f <= 32'b0;
    endcase
    
    zero_flag <= (f == 32'b0) ? 1 : 0;
end

endmodule
