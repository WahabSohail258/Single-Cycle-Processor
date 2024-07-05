module Control_Unit(
    input [6:0] opcode,
    input [5:0] funct,
    input zero,
    output reg RegDst,
    output reg RegWrite,
    output reg ALUsrc,
    output reg MemWrite,
    output reg MemRead,
    output reg Branch,
    output reg MemtoReg,
    output reg PCsrc,
    output reg jump,
    output reg [1:0] Aluop
);

always @(opcode, funct) begin
    RegDst = 1'b0;
    RegWrite = 1'b0;
    ALUsrc = 1'b0;
    MemWrite = 1'b0;
    MemRead = 1'b0;
    Branch = 1'b0;
    Aluop = 2'b00;
    MemtoReg = 1'b0;
    PCsrc = 1'b0;
    jump = 1'b0;
    case(opcode)
        7'd0: begin
            RegDst = 1'b1;
            RegWrite = 1'b1;
            Aluop = 2'b00; // Default value for Aluop
        end
        7'd35: begin // LW
            RegWrite = 1'b1;
            ALUsrc = 1'b1;
            MemRead = 1'b1;
            MemtoReg = 1'b1;
            Aluop = 2'b10;
        end
        7'd43: begin // SW
            ALUsrc = 1'b1;
            MemWrite = 1'b1;
            Aluop = 2'b10;
        end
        7'd4: begin // BEQ
            if (zero)
                PCsrc = 1'b1;
            Branch = 1'b1;
            Aluop = 2'b01; // SUB
        end
        7'd2: begin // Jump
            Aluop = 2'bxx;
            jump = 1'b1;
        end
        7'd42: begin // XORI
            Aluop = 2'b11;
            ALUsrc = 1'b1;
            RegWrite = 1'b1;
        end
        7'd3: begin // SLT
            Aluop = 2'b11;
            RegDst = 1'b1;
            RegWrite = 1'b1;
        end
        default: begin
            // Default case
        end
    endcase
end

endmodule
