`timescale 1ns / 1ps
module RegisterFile #(parameter ADDR_WIDTH = 5, parameter DATA_WIDTH = 32) (
    input clock, input[DATA_WIDTH-1:0] wdata, input[ADDR_WIDTH-1:0] waddr,
    input wen, input reset, input [ADDR_WIDTH-1:0] rs1_addr, input[ADDR_WIDTH-1:0] rs2_addr,
    output logic [DATA_WIDTH-1:0] rs1_value, output logic [DATA_WIDTH-1:0] rs2_value, output logic[DATA_WIDTH-1:0] a0_value
);
    logic[DATA_WIDTH-1:0] rf[2**ADDR_WIDTH-1:0];
    always @(posedge clock) begin
        if (reset) begin
            for (int i = 0; i < 2**ADDR_WIDTH; i++) rf[i] <= 0;
        end else if (wen && waddr != 0) begin  
            rf[waddr] <= wdata;
        end
    end
    assign rs1_value = (rs1_addr == 0) ? 0 : ((wen && waddr == rs1_addr) ? wdata : rf[rs1_addr]);
    assign rs2_value = (rs2_addr == 0) ? 0 : ((wen && waddr == rs2_addr) ? wdata : rf[rs2_addr]);
    assign a0_value = rf[10]; 
endmodule