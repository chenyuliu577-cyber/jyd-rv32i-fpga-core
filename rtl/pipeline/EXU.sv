`include "para.sv"
module EXU (
    input [2:0] funct3_reg, input [3:0] csr_wen_reg, input R_wen_reg,
    input mem_wen_reg, input mem_ren_reg, input [4:0] rd_reg, input[31:0] pc_reg,
    input [3:0] alu_opcode_reg, input inv_flag_reg, input jump_flag_reg,
    input branch_flag_reg, input fetch_i_reg, input [31:0] branch_pc_reg,
    input[31:0] rs2_value_reg, input [31:0] add1_reg, input[31:0] add2_reg, input [31:0] rd_value_reg,
    output [2:0] funct3_next, output [3:0] csr_wen_next, output R_wen_next,
    output mem_wen_next, output mem_ren_next, output[4:0] rd_next, output [31:0] pc_next,
    output jump_flag_next, output [31:0] rs2_value_next, output[31:0] rd_value_next,
    output [31:0] Ex_result, output fetch_i_flag_next, output branch_flag_next, output[31:0] branch_pc_next
);
    logic [31:0] alu_result;
    assign funct3_next = funct3_reg; assign csr_wen_next = csr_wen_reg;
    assign R_wen_next = R_wen_reg; assign mem_wen_next = mem_wen_reg;
    assign mem_ren_next = mem_ren_reg; assign rd_next = rd_reg;
    assign pc_next = pc_reg; assign jump_flag_next = jump_flag_reg;
    assign rs2_value_next = rs2_value_reg; assign rd_value_next = rd_value_reg;
    assign fetch_i_flag_next = fetch_i_reg; assign branch_flag_next = branch_flag_reg;
    assign branch_pc_next = branch_pc_reg;

    ALU #(.BW(32)) ALU_i0 (.d1(add1_reg), .d2(add2_reg), .choice(alu_opcode_reg), .result(alu_result));
    
    logic[31:0] alu_final;
    assign alu_final = alu_result ^ {31'd0, inv_flag_reg};
    assign Ex_result = (jump_flag_reg | (|csr_wen_reg)) ? rd_value_reg : alu_final;
endmodule