`ifndef OPERATOR
    `define AND 4'b0000
    `define XOR 4'b0001
    `define SLL 4'b0010
    `define ADD 4'b0011
    `define SUB 4'b0100
    `define MUL 4'b0101
    `define ADDI 4'b0110
    `define SRAI 4'b0111
    `define OR   4'b1111
`endif

module ALU_Control (
    func_i,
    ALUOp_i,
    ALUCtrl_o
);

input      [9:0] func_i;
input      [1:0] ALUOp_i;
output reg [3:0] ALUCtrl_o;


always @(func_i, ALUOp_i) begin
    ALUCtrl_o = 3'bx;
    if (ALUOp_i == 2'b00) begin
        ALUCtrl_o = `ADDI;
    end
    else if (ALUOp_i == 2'b01) begin
        ALUCtrl_o = `SUB;
    end
    else if (ALUOp_i == 2'b10) begin
        if (func_i[9:3] == 7'b0000001) begin
            ALUCtrl_o = `MUL;
        end
        else if (func_i[9:3] == 7'b0100000) begin
            ALUCtrl_o = `SUB;
        end
        else if (func_i[9:3] == 7'b0000000) begin
            case (func_i[2:0])
                3'b000 : ALUCtrl_o = `ADD; 
                3'b001 : ALUCtrl_o = `SLL; 
                3'b100 : ALUCtrl_o = `XOR;
                3'b110 : ALUCtrl_o = `OR;
                3'b111 : ALUCtrl_o = `AND;
            endcase
        end
    end
    else if (ALUOp_i == 2'b11) begin
        if (func_i[9:3] == 7'b0100000)begin
            ALUCtrl_o = `SRAI;
        end
        else begin
            ALUCtrl_o = `ADDI;
        end
    end
end

endmodule