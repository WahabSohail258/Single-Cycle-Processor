module PC #(parameter N=32)(
    input clk,
    input rst,
    input jump,
    input pc_src, // Branch signal
    input [N-1:0] jump_address,
    input [N-1:0] branch_address, // Branch address input
    output reg [N-1:0] pc_out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        pc_out <= 0;
    else begin
        if (jump)
            pc_out <= jump_address;
        else if (pc_src)
            pc_out <= pc_out + branch_address;
        else
            pc_out <= pc_out + 1;
    end 
end

endmodule
