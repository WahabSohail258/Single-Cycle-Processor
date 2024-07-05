module ALU_Control(
    input [5:0] funct,
    input [1:0] ALUop,
    output reg [3:0] sel_signal
);

always @(*) begin
    case (ALUop)
        2'b00: begin // R-type
            case (funct)
                6'd0: sel_signal = 4'd0; // add
                6'd2: sel_signal = 4'd1; // sub
                6'd4: sel_signal = 4'd2; // mul
                6'd5: sel_signal = 4'd3; // slt
                6'd1: sel_signal = 4'd4; // sll
                default: sel_signal = 4'dx;
            endcase
        end
        2'b01: sel_signal = 4'd1; // beq
        2'b10: sel_signal = 4'd0; // lw/sw
        2'b11: sel_signal = 4'd6; // xori
        default: sel_signal = 4'dx;
    endcase
end

endmodule
