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

module ALU (
    data0_i,
    data1_i,
    ALUCtrl_i,
    data_o,
);

input      [31:0] data0_i, data1_i;
input      [3:0] ALUCtrl_i;

output reg [31:0] data_o;

always @(data0_i, data1_i, ALUCtrl_i) begin
    case (ALUCtrl_i)
        `AND : data_o = data0_i & data1_i;
        `XOR : data_o = data0_i ^ data1_i;
        `SLL : data_o = data0_i << data1_i;
        `ADD : data_o = data0_i + data1_i;
        `SUB : data_o = data0_i - data1_i;
        `MUL : data_o = data0_i * data1_i;
        `ADDI: data_o = data0_i + data1_i;
        `SRAI: data_o = data0_i >>> data1_i[4:0];
        `OR  : data_o = data0_i | data1_i;
    endcase
end

endmodule