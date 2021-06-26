module Control (
    NoOp_i,
    Op_i,
    Ctrl_o,
    Branch_o
);
input        NoOp_i;
input  [6:0] Op_i;
output [6:0] Ctrl_o;
reg    [1:0] ALUOp;
reg    RegWrite, Mem2Reg, MemRead, MemWrite, ALUSrc;
output reg Branch_o;

assign Ctrl_o[0] = RegWrite;
assign Ctrl_o[1] = Mem2Reg;
assign Ctrl_o[2] = MemRead;
assign Ctrl_o[3] = MemWrite;
assign Ctrl_o[5:4] = ALUOp;
assign Ctrl_o[6] = ALUSrc;


always @(*) begin
    if (!NoOp_i) begin
        if (Op_i == 7'b0110011) begin          // add ...
            RegWrite = 1'b1;
            Mem2Reg  = 1'b0;
            MemRead  = 1'b0;
            MemWrite = 1'b0;
            ALUOp    = 2'b10;
            ALUSrc   = 1'b0;
            Branch_o = 0;
        end
        else if (Op_i == 7'b0010011) begin     // addi, ...
            RegWrite = 1'b1;
            Mem2Reg  = 1'b0;
            MemRead  = 1'b0;
            MemWrite = 1'b0;
            ALUOp    = 2'b11;
            ALUSrc   = 1'b1;
            Branch_o = 0;
        end
        else if (Op_i == 7'b0000011) begin     // lw
            RegWrite = 1'b1;
            Mem2Reg  = 1'b1;
            MemRead  = 1'b1;
            MemWrite = 1'b0;
            ALUOp    = 2'b00;
            ALUSrc   = 1'b1;
            Branch_o = 0;
        end
        else if (Op_i == 7'b0100011) begin     // sw
            RegWrite = 1'b0;
            Mem2Reg  = 1'bx;
            MemRead  = 1'b0;
            MemWrite = 1'b1;
            ALUOp    = 2'b00;
            ALUSrc   = 1'b1;
            Branch_o = 0;
        end
        else if (Op_i == 7'b1100011) begin     // beq
            RegWrite = 1'b0;
            Mem2Reg  = 1'bx;
            MemRead  = 1'b0;
            MemWrite = 1'b0;
            ALUOp    = 2'b01;
            ALUSrc   = 1'b1;                   // beq source from immediate(Different from slide)
            Branch_o = 1;
        end
        else begin
            RegWrite = 0;
            Mem2Reg  = 0;
            MemRead  = 0;
            MemWrite = 0;
            ALUOp    = 0;
            ALUSrc   = 0;
            Branch_o = 0;
        end
    end
    else begin
        RegWrite = 0;
        Mem2Reg  = 0;
        MemRead  = 0;
        MemWrite = 0;
        ALUOp    = 0;
        ALUSrc   = 0;
        Branch_o = 0;
    end
end
endmodule