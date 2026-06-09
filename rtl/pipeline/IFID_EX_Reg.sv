`include "para.sv"
module IFID_EX_Reg(
    input clock, input reset, input EXU_inst_clr,
    input valid_last, input ready_last, input ready_next, output logic valid_next,
    input [2:0] funct3, input [3:0] csr_wen, input R_wen, input mem_wen, input mem_ren,
    input [4:0] rd, input[31:0] pc, input[3:0] alu_opcode, input inv_flag, input jump_flag,
    input branch_flag, input fetch_i_flag, input [31:0] branch_pc, input[31:0] rs2_value,
    input[31:0] add1, input[31:0] add2, input [31:0] rd_value,
    input pred_taken_in, input [31:0] pred_target_in,
    output logic [2:0] funct3_reg, output logic [3:0] csr_wen_reg, output logic R_wen_reg,
    output logic mem_wen_reg, output logic mem_ren_reg, output logic[4:0] rd_reg,
    output logic[31:0] pc_reg, output logic[3:0] alu_opcode_reg, output logic inv_flag_reg,
    output logic jump_flag_reg, output logic branch_flag_reg, output logic fetch_i_reg,
    output logic [31:0] branch_pc_reg, output logic[31:0] rs2_value_reg, output logic [31:0] add1_reg,
    output logic[31:0] add2_reg, output logic [31:0] rd_value_reg,
    output logic pred_taken_reg, output logic[31:0] pred_target_reg
);
    always @(posedge clock) begin
        if(reset) valid_next <= 1'b0;
        else if(ready_next) valid_next <= (EXU_inst_clr) ? 1'b0 : valid_last;
    end
    always @(posedge clock) begin
        if(reset) begin
            funct3_reg <= 0; rd_reg <= 0; alu_opcode_reg <= 0; inv_flag_reg <= 0;
            rs2_value_reg <= 0; add1_reg <= 0; add2_reg <= 0; rd_value_reg <= 0;
            branch_pc_reg <= 0; pc_reg <= 0; pred_taken_reg <= 0; pred_target_reg <= 0;
        end else if(ready_next) begin
            funct3_reg <= funct3; rd_reg <= rd; alu_opcode_reg <= alu_opcode; inv_flag_reg <= inv_flag;
            rs2_value_reg <= rs2_value; add1_reg <= add1; add2_reg <= add2; rd_value_reg <= rd_value;
            branch_pc_reg <= branch_pc; pc_reg <= pc; pred_taken_reg <= pred_taken_in; pred_target_reg <= pred_target_in;
        end
    end
    always @(posedge clock) begin
        if(reset) begin
            mem_ren_reg <= 0; csr_wen_reg <= 0; R_wen_reg <= 0; mem_wen_reg <= 0; jump_flag_reg <= 0; branch_flag_reg <= 0; fetch_i_reg <= 0;
        end else if(ready_next) begin
            if (!valid_last || EXU_inst_clr) begin 
                mem_ren_reg <= 0; csr_wen_reg <= 0; R_wen_reg <= 0; mem_wen_reg <= 0; jump_flag_reg <= 0; branch_flag_reg <= 0; fetch_i_reg <= 0;
            end else begin
                mem_ren_reg <= mem_ren; csr_wen_reg <= csr_wen; R_wen_reg <= R_wen; mem_wen_reg <= mem_wen; jump_flag_reg <= jump_flag; branch_flag_reg <= branch_flag; fetch_i_reg <= fetch_i_flag;
            end
        end
    end
endmodule