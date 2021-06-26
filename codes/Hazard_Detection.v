module Hazard_Detection (
    ID_EX_MemRead_i,
    ID_EX_RDaddr_i,
    RS1addr_i,
    RS2addr_i,
    NoOp_o,
    PCWrite_o,
    Stall_o
);

input ID_EX_MemRead_i;
input [4:0]  ID_EX_RDaddr_i, RS1addr_i, RS2addr_i;

output reg NoOp_o, PCWrite_o, Stall_o;

always @(ID_EX_RDaddr_i, RS1addr_i, RS2addr_i) begin
    NoOp_o = 0;
    PCWrite_o = 1;
    Stall_o = 0;
    if (ID_EX_MemRead_i && (ID_EX_RDaddr_i == RS1addr_i || ID_EX_RDaddr_i == RS2addr_i)) begin
        NoOp_o = 1;
        Stall_o = 1;
        PCWrite_o = 0;
    end
        
end

endmodule