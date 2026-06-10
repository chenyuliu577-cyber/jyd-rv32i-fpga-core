/* verilator lint_off UNUSEDSIGNAL */
`timescale 1ns / 1ps
module LSU(
    input mem_ren_reg, input mem_wen_reg, input R_wen_reg, input [3:0] csr_wen_reg,
    input [31:0] Ex_result_reg, input[4:0] rd_reg, input [2:0] funct3_reg, input[31:0] rs2_value_reg,
    input jump_flag_reg, input[31:0] rd_value_reg, input[31:0] pc_reg,
    output [31:0] rd_value_next, output R_wen_next, output [31:0] LSU_Rdata, output [3:0] csr_wen_next,
    output [31:0] Ex_result_next, output[4:0] rd_next, output mem_ren_next, output jump_flag_next, output[31:0] pc_next,
    output [31:0] addr, output wen, output[31:0] wdata, output [1:0] mask, input [31:0] rdata
);
    logic [31:0] rdata_8i, rdata_16i, rdata_8u, rdata_16u, rdata_ex;
    assign rd_value_next = rd_value_reg; assign R_wen_next = R_wen_reg;
    assign csr_wen_next = csr_wen_reg; assign Ex_result_next = Ex_result_reg;
    assign rd_next = rd_reg; assign mem_ren_next = mem_ren_reg;
    assign jump_flag_next = jump_flag_reg; assign pc_next = pc_reg;
    assign addr = Ex_result_reg; assign wen = mem_wen_reg; assign mask = funct3_reg[1:0];

    logic [31:0] aligned_wdata;
    always_comb begin
        case (funct3_reg[1:0])
            2'b00: aligned_wdata = {4{rs2_value_reg[7:0]}};  // SB
            2'b01: aligned_wdata = {2{rs2_value_reg[15:0]}}; // SH
            default: aligned_wdata = rs2_value_reg;          // SW
        endcase
    end
    assign wdata = aligned_wdata;

    assign rdata_8u = {24'd0, rdata[7:0]};
    assign rdata_16u = {16'd0, rdata[15:0]};
    always_comb begin
        case (funct3_reg)
            3'b000: rdata_ex = rdata_8i;
            3'b001: rdata_ex = rdata_16i;
            3'b010: rdata_ex = rdata;
            3'b100: rdata_ex = rdata_8u;
            3'b101: rdata_ex = rdata_16u;
            default: rdata_ex = 32'b0;
        endcase
    end
    assign LSU_Rdata = rdata_ex;
    /* verilator lint_off PINMISSING */
    sext #( .DATA_WIDTH(8), .OUT_WIDTH(32) ) sext_i8 ( .data(rdata[7:0]), .sext_data(rdata_8i) );
    sext #( .DATA_WIDTH(16), .OUT_WIDTH(32) ) sext_i16 ( .data(rdata[15:0]), .sext_data(rdata_16i) );
endmodule
