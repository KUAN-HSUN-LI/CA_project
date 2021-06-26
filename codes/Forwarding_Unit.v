module Forwarding_Unit (
    EX_RS1addr_i,
    EX_RS2addr_i,
    MEM_RegWrite_i,
    MEM_RDaddr_i,
    WB_RegWrite_i,
    WB_RDaddr_i,
    ForwardA_o,
    ForwardB_o
);

input [4:0] EX_RS1addr_i, EX_RS2addr_i;
input MEM_RegWrite_i;
input [4:0] MEM_RDaddr_i;
input WB_RegWrite_i;
input [4:0] WB_RDaddr_i;

output reg [1:0] ForwardA_o, ForwardB_o;

always @(EX_RS1addr_i, EX_RS2addr_i, MEM_RegWrite_i, MEM_RDaddr_i, WB_RegWrite_i, WB_RDaddr_i) begin
    ForwardA_o = 0;
    ForwardB_o = 0;
    if (MEM_RegWrite_i && (MEM_RDaddr_i != 0) && (MEM_RDaddr_i == EX_RS1addr_i))
        ForwardA_o = 2'b10;
    if (MEM_RegWrite_i && (MEM_RDaddr_i != 0) && (MEM_RDaddr_i == EX_RS2addr_i))
        ForwardB_o = 2'b10;
    if (WB_RegWrite_i && (WB_RDaddr_i != 0) && (WB_RDaddr_i == EX_RS1addr_i) && 
        !(MEM_RegWrite_i && (MEM_RDaddr_i != 0) && (MEM_RDaddr_i == EX_RS1addr_i)))
        ForwardA_o = 2'b01;
    if (WB_RegWrite_i && (WB_RDaddr_i != 0) && (WB_RDaddr_i == EX_RS2addr_i) && 
        !(MEM_RegWrite_i && (MEM_RDaddr_i != 0) && (MEM_RDaddr_i == EX_RS2addr_i)))
        ForwardB_o = 2'b01;
end 

endmodule