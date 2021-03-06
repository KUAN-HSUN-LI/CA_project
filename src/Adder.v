module Adder(
    data0_in,
    data1_in,
    data_o
);
input signed  [31:0] data0_in, data1_in;
output signed [31:0] data_o;

assign data_o = data0_in + data1_in;

endmodule