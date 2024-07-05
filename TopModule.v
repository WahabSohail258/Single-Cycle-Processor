module Test_Processor(
   
    //PC
    input  clk, rst,
    output zero_flag
);
    
    //ROM
    wire  [31:0] instruction;
    //splitter
    wire [15:0] offset;
    wire [5:0] funct;
    wire [4:0] shift;
    wire [4:0] rd;  // RegisterFile
    wire  [4:0] rs2; // RegisterFile
    wire [4:0] rs1; // RegisterFile
    wire[6:0] opcode;
    wire [25:0] imme;
    //ALU
    reg[31:0] alu_result;
    //REG file
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;
    //Data Mem
    wire [31:0] read_data;
    wire [31:0] write_data;

    //ALU Ctrl
    wire  [3:0] sel_signal_ALU;
    //sign ext
    wire [31:0] sign_ext;
    // control signals
    wire RegDst, RegWrite, ALUsrc, MemWrite, MemRead, Branch,jump;
    wire[1:0]Aluop;
    wire MemtoReg, PCsrc;


///pc 

   wire [31:0] branch_address;
   wire [31:0] pc_out;
   wire [31:0] jump_address;


    reg [4:0]rd_;
    reg [31:0]read_data_2_reg;
    wire pc_src;



//branch address
assign branch_address=sign_ext;

//jump address
assign jump_address={6'b0,instruction[25:0]};

// Instantiate Program Counter module

assign pc_src = Branch && zero_flag;

PC uut_PC(
    .clk(clk),
    .rst(rst),
    .jump(jump),
    .pc_src(pc_src),
    .jump_address(jump_address),
    .branch_address(branch_address), 
    .pc_out(pc_out)
);

    ROM uut_rom (
        .address(pc_out),   // Input from Test_Processor
        .instruction(instruction) // Output to ROM
    );

    Splitter uut_splitter (
        .instruction(instruction), // Input from ROM
        .opcode(opcode),           // Output to Control_Unit
        .offset(offset),           // Output to Control_Unit
        .rs1(rs1),                 // Output to RegisterFile
        .rs2(rs2),                 // Output to RegisterFile
        .rd(rd),                   // Output to RegisterFile
        .shamt(shift),             // Output to RegisterFile
        .funct(funct),
        .imme(imme)             // Output to Control_Unit
    );

    RegisterFile uut_regfile (
        .clk(clk),
        .reset(rst),                   // Input from Test_Processor
        .write(RegWrite),           // Input from Test_Processor
        .write_data(write_data),     // Input from ALU_32bit
        .rs_address(rs1),            // Input from Splitter
        .rd_address(rd_),             // Input from Splitter
        .rt_address(rs2),            // Input from Splitter
        .read_data_1(read_data_1),    // Output to Splitter
        .read_data_2(read_data_2)     // Output to Splitter
    );

    ALU_32bit uut_alu (
        .opcode(sel_signal_ALU),         // Input from Splitter
        .a(read_data_1),             // Input from RegisterFile
        .b(read_data_2_reg), // Input from RegisterFile or Sign Extender
        .shift(shift),
        .f(write_data),              // Output to Test_Processor
        .zero_flag(zero_flag)        // Output to Test_Processor
    );

    data_memory uut_memory (
        .address(write_data),       // Input from Test_Processor
        .write_data(read_data_2_reg),     // Input from Test_Processor
        .sig_memread(MemRead),       // Input from Test_Processor
        .sig_memwrite(MemWrite),     // Input from Test_Processor
        .read_data(read_data)        // Output to Test_Processor
    );

    sign_extend uut_sign(
         .imm(offset),                // Input from Test_Processor
         .full(sign_ext)              // Output to Test_Processor
    );

    Control_Unit uut_control (
        .opcode(opcode),             // Input from Splitter
        .funct(funct),               // Input from Splitter
        .zero(zero_flag),            // Input from ALU_32bit
        .RegDst(RegDst),             // Output to RegisterFile
        .RegWrite(RegWrite),         // Output to RegisterFile
        .ALUsrc(ALUsrc),             // Output to ALU_32bit
        .MemWrite(MemWrite),         // Output to data_memory
        .MemRead(MemRead),           // Output to data_memory
        .Branch(Branch),             // Output to PC
        .Aluop(Aluop),               // Output to ALU_Control
        .MemtoReg(MemtoReg),         // Output to RegisterFile
        .PCsrc(PCsrc),
        .jump(jump)                // Output to PC
    );

    ALU_Control alu_control_inst (
        .funct(funct),               // Input from Splitter
        .ALUop(Aluop),               // Input from Splitter
        .sel_signal(sel_signal_ALU)  // Output to ALU_32bit
    );
    Write_RT uutrt(
    .clk(clk),
    .alu_result(alu_result),
    .rt(rs2)
    );

        always @(*) begin
        if(RegDst == 1)
            rd_ = rd;
        else
            rd_ = rs2;
    end

    always @(*) begin
        if(ALUsrc == 1)
            read_data_2_reg <= sign_ext;
        else
            read_data_2_reg <= read_data_2;
    end

    always @(*) begin
        if(MemtoReg == 1)
            alu_result <= read_data;
        else
            alu_result <= write_data;
    end
assign alu_ = alu_result;

endmodule
