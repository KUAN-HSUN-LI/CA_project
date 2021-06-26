module MUX4 (
    data0_i,
    data1_i,
    data2_i,
    data3_i,
    select_i,
    data_o
);

input [31:0] data0_i, data1_i, data2_i, data3_i;
input [1:0]  select_i;

output reg [31:0] data_o;

always @(data0_i, data1_i, data2_i, data3_i, select_i) begin
    case (select_i)
        2'b00 : data_o = data0_i; 
        2'b01 : data_o = data1_i; 
        2'b10 : data_o = data2_i;
        2'b11 : data_o = data3_i;
    endcase
end

endmodule