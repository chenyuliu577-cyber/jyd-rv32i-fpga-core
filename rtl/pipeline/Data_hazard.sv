`timescale 1ns / 1ps
module Data_hazard(
    input [4:0] IDU_rs1, input[4:0] IDU_rs2,
    input [4:0] EXU_rd, input EXU_R_Wen,
    input [4:0] MEM_rd, input MEM_R_Wen, 
    output [1:0] IDU_rs1_choice, output [1:0] IDU_rs2_choice
);
    logic exu_rs1_match, exu_rs2_match, mem_rs1_match, mem_rs2_match;
    assign exu_rs1_match = (EXU_rd == IDU_rs1) && (EXU_rd != 5'b0);
    assign exu_rs2_match = (EXU_rd == IDU_rs2) && (EXU_rd != 5'b0);
    assign mem_rs1_match = (MEM_rd == IDU_rs1) && (MEM_rd != 5'b0);
    assign mem_rs2_match = (MEM_rd == IDU_rs2) && (MEM_rd != 5'b0);

    assign IDU_rs1_choice = (EXU_R_Wen && exu_rs1_match) ? 2'b01 : ((MEM_R_Wen && mem_rs1_match) ? 2'b10 : 2'b00);
    assign IDU_rs2_choice = (EXU_R_Wen && exu_rs2_match) ? 2'b01 : ((MEM_R_Wen && mem_rs2_match) ? 2'b10 : 2'b00);
endmodule