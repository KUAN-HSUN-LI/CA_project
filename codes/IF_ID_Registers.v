module IF_ID_Registers (
    clk_i,
    stall_i,
    Flush_i,
    cpu_stall_i,
    pc_i,
    data_i,
    pc_o,
    data_o
);

input             clk_i, stall_i, Flush_i, cpu_stall_i;
input      [31:0] pc_i, data_i;
output reg [31:0] pc_o, data_o, pc_new, data_new;

always @(posedge clk_i) begin
    if (~cpu_stall_i)begin
        pc_o <= pc_new;
        data_o <= data_new;
    end

end

always @(*) begin    
    if (Flush_i) begin
        pc_new = pc_i;
        data_new = 0;  
    end
    else if (stall_i) begin
        pc_new   = pc_o;
        data_new = data_o;    
    end
    else begin
        pc_new = pc_i;
        data_new = data_i;
    end 
end

endmodule