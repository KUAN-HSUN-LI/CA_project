module CPU
(
    clk_i, 
    rst_i,
    start_i,
    mem_data_i, 
    mem_ack_i,    
    mem_data_o, 
    mem_addr_o,     
    mem_enable_o, 
    mem_write_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input [255:0]              mem_data_i;
input               mem_ack_i;    
output [255:0]              mem_data_o; 
output [31:0]              mem_addr_o;     
output               mem_enable_o; 
output               mem_write_o;

// Wires
// IF/ID
wire [31:0] PC_MUX, PC_o, pc_mem_new;
wire [31:0] instr_o, IF_ID_o, IF_ID_PC_o;

// ID/EX
wire        NoOp_o, PCWrite_o, Stall_o;
wire [31:0] imm_o, ID_EX_Imm_o;
wire [6:0]  ctrl_o, ID_EX_Ctrl_o;
wire        Branch_o;
wire [31:0] Add_Imm_o;
wire  Flush;
wire [31:0] reg_o1, reg_o2, ID_EX_Reg_o1, ID_EX_Reg_o2;
wire [9:0]  ID_EX_func_o;
wire [4:0]  ID_EX_RS1addr_o, ID_EX_RS2addr_o, ID_EX_RDaddr_o;

// EX/MEM
wire [3:0]  EX_MEM_Ctrl_o;
wire [31:0] Forward_MUX_A, Forward_MUX_B; 
wire [31:0] mux2ALU;
wire [3:0]  ALUCtrl_o;
wire [31:0] ALU_o, EX_MEM_ALU_Result_o;
wire [1:0]  ForwardA_o, ForwardB_o;
wire [31:0] EX_MEM_Reg_o2;
wire [4:0]  EX_MEM_RDaddr_o;
//
wire        cpu_stall;

// MEM/WB
wire [1:0]  MEM_WB_Ctrl_o;
wire [31:0] MEM_WB_ALU_Result_o;
wire [31:0] MEM_o, MEM_WB_MEM_Result_o;
wire [4:0]  MEM_WB_RDaddr_o;

wire [31:0] WB_MUX;

assign Flush = (Branch_o && (reg_o1 == reg_o2));

MUX32 MUX_PCSrc(
    .data0_i(pc_mem_new),
    .data1_i(Add_Imm_o),
    .select_i(Flush),
    .data_o(PC_MUX)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (PCWrite_o),
    .cpu_stall_i(cpu_stall),
    .pc_i       (PC_MUX),
    .pc_o       (PC_o)
);

Adder Add_PC(
    .data0_in   (PC_o),
    .data1_in   (4),
    .data_o     (pc_mem_new)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC_o), 
    .instr_o    (instr_o)
);

IF_ID_Registers IF_ID_Registers(
    .clk_i(clk_i),
    .stall_i(Stall_o),
    .Flush_i(Flush),
    .cpu_stall_i(cpu_stall),
    .pc_i(PC_o),
    .data_i(instr_o),
    .pc_o(IF_ID_PC_o),
    .data_o(IF_ID_o)
);

Hazard_Detection Hazard_Detection(
    .ID_EX_MemRead_i(ID_EX_Ctrl_o[2]),
    .ID_EX_RDaddr_i(ID_EX_RDaddr_o),
    .RS1addr_i(IF_ID_o[19:15]),
    .RS2addr_i(IF_ID_o[24:20]),
    .NoOp_o(NoOp_o),
    .PCWrite_o(PCWrite_o),
    .Stall_o(Stall_o)
);

Control Control(
    .NoOp_i     (NoOp_o),
    .Op_i       (IF_ID_o[6:0]),
    .Ctrl_o     (ctrl_o),
    .Branch_o   (Branch_o)
);

Adder Add_Imm(
    .data0_in   (imm_o),
    .data1_in   (IF_ID_PC_o),
    .data_o     (Add_Imm_o)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i  (IF_ID_o[19:15]),
    .RS2addr_i  (IF_ID_o[24:20]),
    .RDaddr_i   (MEM_WB_RDaddr_o), 
    .RDdata_i   (WB_MUX),
    .RegWrite_i (MEM_WB_Ctrl_o[0]), 
    .RS1data_o  (reg_o1), 
    .RS2data_o  (reg_o2) 
);

Imm_Gen Imm_Gen(
    .data_i     (IF_ID_o),
    .data_o     (imm_o)
);

ID_EX_Registers ID_EX_Registers(
    .clk_i(clk_i),
    .Ctrl_i(ctrl_o),
    .RS1data_i(reg_o1),
    .RS2data_i(reg_o2),
    .Imm_i(imm_o),
    .func_i({IF_ID_o[31:25], IF_ID_o[14:12]}),
    .RS1addr_i(IF_ID_o[19:15]),
    .RS2addr_i(IF_ID_o[24:20]),
    .RDaddr_i(IF_ID_o[11:7]),
    .cpu_stall_i(cpu_stall),
    .Ctrl_o(ID_EX_Ctrl_o),
    .RS1data_o(ID_EX_Reg_o1),
    .RS2data_o(ID_EX_Reg_o2),
    .Imm_o(ID_EX_Imm_o),
    .func_o(ID_EX_func_o),
    .RS1addr_o(ID_EX_RS1addr_o),
    .RS2addr_o(ID_EX_RS2addr_o),
    .RDaddr_o(ID_EX_RDaddr_o)
);

MUX4 MUX_ForwardA(
    .data0_i(ID_EX_Reg_o1),
    .data1_i(WB_MUX),
    .data2_i(EX_MEM_ALU_Result_o),
    .data3_i(),
    .select_i(ForwardA_o),
    .data_o(Forward_MUX_A)
);

MUX4 MUX_ForwardB(
    .data0_i(ID_EX_Reg_o2),
    .data1_i(WB_MUX),
    .data2_i(EX_MEM_ALU_Result_o),
    .data3_i(),
    .select_i(ForwardB_o),
    .data_o(Forward_MUX_B)
);

MUX32 MUX_ALUSrc(
    .data0_i    (Forward_MUX_B),
    .data1_i    (ID_EX_Imm_o),
    .select_i   (ID_EX_Ctrl_o[6]),
    .data_o     (mux2ALU)
);

ALU_Control ALU_Control(
    .func_i     (ID_EX_func_o),
    .ALUOp_i    (ID_EX_Ctrl_o[5:4]),
    .ALUCtrl_o  (ALUCtrl_o)
);

ALU ALU(
    .data0_i    (Forward_MUX_A),
    .data1_i    (mux2ALU),
    .ALUCtrl_i  (ALUCtrl_o),
    .data_o     (ALU_o)
);

Forwarding_Unit Forwarding_Unit(
    .EX_RS1addr_i(ID_EX_RS1addr_o),
    .EX_RS2addr_i(ID_EX_RS2addr_o),
    .MEM_RegWrite_i(EX_MEM_Ctrl_o[0]),
    .MEM_RDaddr_i(EX_MEM_RDaddr_o),
    .WB_RegWrite_i(MEM_WB_Ctrl_o[0]),
    .WB_RDaddr_i(MEM_WB_RDaddr_o),
    .ForwardA_o(ForwardA_o),
    .ForwardB_o(ForwardB_o)
);

EX_MEM_Registers EX_MEM_Registers 
(
    .clk_i(clk_i),
    .Ctrl_i(ID_EX_Ctrl_o[3:0]),
    .ALU_Result_i(ALU_o),
    .RS2data_i(Forward_MUX_B),
    .RDaddr_i(ID_EX_RDaddr_o),
    .cpu_stall_i(cpu_stall),
    .Ctrl_o(EX_MEM_Ctrl_o),
    .ALU_Result_o(EX_MEM_ALU_Result_o),
    .RS2data_o(EX_MEM_Reg_o2),
    .RDaddr_o(EX_MEM_RDaddr_o)
);


dcache_controller dcache(
    .clk_i(clk_i), 
    .rst_i(rst_i),
    .mem_data_i(mem_data_i), 
    .mem_ack_i(mem_ack_i),     
    .mem_data_o(mem_data_o), 
    .mem_addr_o(mem_addr_o),     
    .mem_enable_o(mem_enable_o), 
    .mem_write_o(mem_write_o), 
    .cpu_data_i(EX_MEM_Reg_o2), 
    .cpu_addr_i(EX_MEM_ALU_Result_o),     
    .cpu_MemRead_i(EX_MEM_Ctrl_o[2]), 
    .cpu_MemWrite_i(EX_MEM_Ctrl_o[3]), 
    .cpu_data_o(MEM_o), 
    .cpu_stall_o(cpu_stall)
);

MEM_WB_Registers MEM_WB_Registers 
(
    .clk_i(clk_i),
    .Ctrl_i(EX_MEM_Ctrl_o[1:0]),
    .ALU_Result_i(EX_MEM_ALU_Result_o),
    .MEM_Result_i(MEM_o),
    .RDaddr_i(EX_MEM_RDaddr_o),
    .Ctrl_o(MEM_WB_Ctrl_o),
    .ALU_Result_o(MEM_WB_ALU_Result_o),
    .MEM_Result_o(MEM_WB_MEM_Result_o),
    .RDaddr_o(MEM_WB_RDaddr_o)
);

MUX32 MUX_REGSrc(
    .data0_i    (MEM_WB_ALU_Result_o),
    .data1_i    (MEM_WB_MEM_Result_o),
    .select_i   (MEM_WB_Ctrl_o[1]),
    .data_o     (WB_MUX)
);

endmodule

