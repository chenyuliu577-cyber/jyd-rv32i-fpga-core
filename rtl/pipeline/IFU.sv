`timescale 1ns / 1ps
module IFU(
    input clock, input reset, input [31:0] dnpc, input dnpc_flag,
    input [31:0] irom_data, input stall,
    input bpu_pred_taken, input[31:0] bpu_pred_target, 
    output [31:0] snpc, output logic[31:0] pc, output [31:0] inst,
    input ready, output logic valid
);
    assign valid = 1'b1;
    assign snpc = pc + 4;
    assign inst = irom_data;

    always @(posedge clock) begin
        if (reset) pc <= 32'h8000_0000;
        else if (stall & valid & ready) pc <= pc;
        else if (dnpc_flag & valid & ready) pc <= dnpc; // Ô¤²âÊ§°Ü¾ÀÕı
        else if (bpu_pred_taken & valid & ready) pc <= bpu_pred_target; // Ô¤²âÌø×ª
        else if (valid & ready) pc <= snpc;
    end
endmodule