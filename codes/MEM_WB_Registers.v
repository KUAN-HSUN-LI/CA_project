module MEM_WB_Registers 
(
    clk_i,
    Ctrl_i,
    ALU_Result_i,
    MEM_Result_i,
    RDaddr_i,
    cpu_stall_i,
    Ctrl_o,
    ALU_Result_o,
    MEM_Result_o,
    RDaddr_o
);

input                clk_i, cpu_stall_i;
input  [1:0]         Ctrl_i;
input  [31:0]        ALU_Result_i, MEM_Result_i;
input  [4:0]         RDaddr_i;

output reg [1:0]     Ctrl_o;
output reg [31:0]    ALU_Result_o, MEM_Result_o;
output reg [4:0]     RDaddr_o;



always @(posedge clk_i) begin
    if (~cpu_stall_i)begin
        Ctrl_o       <= Ctrl_i;
        ALU_Result_o <= ALU_Result_i;
        MEM_Result_o <= MEM_Result_i;
        RDaddr_o     <= RDaddr_i;
    end
end

endmodule