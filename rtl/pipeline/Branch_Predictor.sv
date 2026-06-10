`timescale 1ns / 1ps
module Branch_Predictor #(parameter INDEX_BITS = 12) (
    input clk, input rst,
    input  [31:0] if_pc,
    output logic  pred_taken,
    output logic[31:0] pred_target,
    input         update_en,
    input  [31:0] update_pc,
    input         update_taken,
    input  [31:0] update_target
);
    localparam ENTRIES = 1 << INDEX_BITS;
    logic[1:0]  bht [ENTRIES-1:0];
    logic [31:0] btb[ENTRIES-1:0];
    logic [31:0] tag_arr [ENTRIES-1:0];
    logic        valid[ENTRIES-1:0];

    initial begin
        for (int i=0; i<ENTRIES; i++) bht[i] = 2'b01;
    end

    logic[INDEX_BITS-1:0] read_idx, write_idx;
    assign read_idx = if_pc[INDEX_BITS+1 : 2];
    assign write_idx = update_pc[INDEX_BITS+1 : 2];

    assign pred_taken = valid[read_idx] && (tag_arr[read_idx] == if_pc) && (bht[read_idx][1] == 1'b1);
    assign pred_target = btb[read_idx];

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < ENTRIES; i++) valid[i] <= 1'b0;
        end else if (update_en) begin
            valid[write_idx] <= 1'b1;
            tag_arr[write_idx] <= update_pc;
            btb[write_idx] <= update_target;
            if (valid[write_idx] && tag_arr[write_idx] == update_pc) begin
                case (bht[write_idx])
                    2'b00: bht[write_idx] <= update_taken ? 2'b01 : 2'b00;
                    2'b01: bht[write_idx] <= update_taken ? 2'b10 : 2'b00;
                    2'b10: bht[write_idx] <= update_taken ? 2'b11 : 2'b01;
                    2'b11: bht[write_idx] <= update_taken ? 2'b11 : 2'b10;
                endcase
            end else begin
                bht[write_idx] <= update_taken ? 2'b10 : 2'b01;
            end
        end
    end
endmodule
