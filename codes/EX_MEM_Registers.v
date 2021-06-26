module EX_MEM_Registers 
(
    clk_i,
    Ctrl_i,
    ALU_Result_i,
    RS2data_i,
    RDaddr_i,
    cpu_stall_i,
    Ctrl_o,
    ALU_Result_o,
    RS2data_o,
    RDaddr_o
);

input                clk_i, cpu_stall_i;
input  [3:0]         Ctrl_i;
input  [31:0]        ALU_Result_i, RS2data_i;
input  [4:0]         RDaddr_i;

output reg [3:0]     Ctrl_o;
output reg [31:0]    ALU_Result_o, RS2data_o;
output reg [4:0]     RDaddr_o;



always @(posedge clk_i) begin
    if (~cpu_stall_i) begin
        Ctrl_o       <= Ctrl_i;
        ALU_Result_o <= ALU_Result_i;
        RS2data_o    <= RS2data_i;
        RDaddr_o  <= RDaddr_i;
    end
end

endmodule