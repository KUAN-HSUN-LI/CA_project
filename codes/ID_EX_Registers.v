module ID_EX_Registers 
(
    clk_i,
    Ctrl_i,
    RS1data_i,
    RS2data_i,
    Imm_i,
    func_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i,
    cpu_stall_i,
    Ctrl_o,
    RS1data_o,
    RS2data_o,
    Imm_o,
    func_o,
    RS1addr_o,
    RS2addr_o,
    RDaddr_o
);

input                clk_i, cpu_stall_i;
input  [6:0]         Ctrl_i;
input  [31:0]        RS1data_i, RS2data_i, Imm_i;
input  [9:0]         func_i;
input  [4:0]         RS1addr_i, RS2addr_i, RDaddr_i;

output reg [6:0]     Ctrl_o;
output reg [31:0]    RS1data_o, RS2data_o, Imm_o;
output reg [9:0]     func_o;
output reg [4:0]     RS1addr_o, RS2addr_o, RDaddr_o;


always @(posedge clk_i) begin
    if (~cpu_stall_i) begin
        Ctrl_o    <= Ctrl_i;
        RS1data_o <= RS1data_i;
        RS2data_o <= RS2data_i;
        Imm_o     <= Imm_i;
        func_o    <= func_i;
        RS1addr_o <= RS1addr_i;
        RS2addr_o <= RS2addr_i;
        RDaddr_o  <= RDaddr_i;
    end
end

endmodule