`timescale 1ns / 1ps
module IF_ID_Reg (
    input clock, input reset, input flush, input stall,
    input [31:0] if_pc, input [31:0] if_inst, input if_pred_taken, input[31:0] if_pred_target,
    output logic [31:0] id_pc,
    (* max_fanout = 16 *) output logic [31:0] id_inst,
    output logic id_pred_taken, output logic [31:0] id_pred_target
);
    always_ff @(posedge clock) begin
        if (reset | flush) begin
            id_pc          <= 32'h0000_0000;
            id_inst        <= 32'h0000_0013; // NOP
            id_pred_taken  <= 1'b0;
            id_pred_target <= 32'h0000_0000;
        end else if (!stall) begin
            id_pc          <= if_pc;
            id_inst        <= if_inst;
            id_pred_taken  <= if_pred_taken;
            id_pred_target <= if_pred_target;
        end
    end
endmodule
