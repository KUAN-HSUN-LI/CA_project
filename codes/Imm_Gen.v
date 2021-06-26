module Imm_Gen (
    data_i,
    data_o
);

input             [31:0] data_i;
output reg signed [31:0] data_o;

always @(data_i) begin
    data_o = 0;
    if (data_i[6:0] == 7'b0010011) begin
        data_o = {{20{data_i[31]}}, data_i[31:20]};
    end
    else if (data_i[6:0] == 7'b0000011) begin
        data_o = {{20{data_i[31]}}, data_i[31:20]};
    end
    else if (data_i[6:0] == 7'b0100011) begin
        data_o = {{20{data_i[31]}}, data_i[31:25], data_i[11:7]};
    end
    else if (data_i[6:0] == 7'b1100011) begin
        data_o = {{19{data_i[31]}}, data_i[31], data_i[7], data_i[30:25], data_i[11:8], 1'b0};
    end
end

endmodule