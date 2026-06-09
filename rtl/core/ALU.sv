`timescale 1ns / 1ps
`include "para.sv"
module ALU #(parameter BW = 32) (
    input  logic [BW-1:0] d1, input  logic[BW-1:0] d2,
    input  logic [3:0]    choice, output logic [BW-1:0] result
);
    logic          is_sub;
    logic[BW-1:0] add_sub_res;
    logic          is_eq, is_slt, is_sltu;
    
    assign is_sub = (choice == `alu_sub) || (choice == `alu_signed_comparator) || 
                    (choice == `alu_unsigned_comparator) || (choice == `alu_equal);
    assign add_sub_res = d1 + (is_sub ? ~d2 : d2) + { {(BW-1){1'b0}}, is_sub };

    assign is_eq   = (add_sub_res == {BW{1'b0}});
    assign is_slt  = (d1[BW-1] == d2[BW-1]) ? add_sub_res[BW-1] : d1[BW-1];
    assign is_sltu = (d1[BW-1] == d2[BW-1]) ? add_sub_res[BW-1] : d2[BW-1];

    always_comb begin
        result = {BW{1'b0}}; 
        case(choice)
            `alu_add, `alu_sub:       result = add_sub_res;
            `alu_and:                 result = d1 & d2;
            `alu_or:                  result = d1 | d2;
            `alu_xor:                 result = d1 ^ d2;
            `alu_sll:                 result = d1 << d2[4:0];
            `alu_srl:                 result = d1 >> d2[4:0];
            `alu_sra:                 result = $signed(d1) >>> d2[4:0];
            `alu_signed_comparator:   result = { {(BW-1){1'b0}}, is_slt };
            `alu_unsigned_comparator: result = { {(BW-1){1'b0}}, is_sltu };
            `alu_equal:               result = { {(BW-1){1'b0}}, is_eq };
            default:                  result = {BW{1'b0}};
        endcase
    end
endmodule