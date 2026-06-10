`timescale 1ns / 1ps
module MEM_WB_Reg(
    input clock, input reset,
    input [31:0] mem_rdata_in, input [31:0] ex_result_in, input [31:0] rd_value_in,
    input [4:0] rd_in, input [3:0] csr_wen_in, input r_wen_in,
    input mem_ren_in, input jump_flag_in, input [31:0] pc_in, input valid_in,

    output logic[31:0] mem_rdata_reg, output logic [31:0] ex_result_reg, output logic [31:0] rd_value_reg,
    output logic [4:0] rd_reg, output logic[3:0] csr_wen_reg, output logic r_wen_reg,
    output logic mem_ren_reg, output logic jump_flag_reg, output logic[31:0] pc_reg, output logic valid_reg
);
    always_ff @(posedge clock) begin
        if (reset) begin
            valid_reg <= 0;
            mem_rdata_reg <= 0; ex_result_reg <= 0; rd_value_reg <= 0; rd_reg <= 0; pc_reg <= 0;
            csr_wen_reg <= 0; r_wen_reg <= 0; mem_ren_reg <= 0; jump_flag_reg <= 0;
        end else begin
            valid_reg <= valid_in;
            mem_rdata_reg <= mem_rdata_in; ex_result_reg <= ex_result_in; rd_value_reg <= rd_value_in;
            rd_reg <= rd_in; pc_reg <= pc_in;

            // ? ¾»»¯Âß¼­
            if (!valid_in) begin
                csr_wen_reg <= 0; r_wen_reg <= 0; mem_ren_reg <= 0; jump_flag_reg <= 0;
            end else begin
                csr_wen_reg <= csr_wen_in; r_wen_reg <= r_wen_in; mem_ren_reg <= mem_ren_in; jump_flag_reg <= jump_flag_in;
            end
        end
    end
endmodule
