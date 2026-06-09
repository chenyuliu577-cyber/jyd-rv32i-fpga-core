/*interface define*/


// __opcode__

`define R_opcode  7'b0110011
`define lw 7'b0000011                          //lw
`define addi 7'b0010011                          //addi
`define jarl 7'b1100111                          //jalr
`define S_opcode  7'b0100011 
`define B_opcode  7'b1100011
`define lui 7'b0110111                          //lui
`define auipc 7'b0010111                          //auipc
`define jal  7'b1101111                          //jal
`define M_opcode  7'b1110011

// alu
`define alu_add                   4'b0000
`define alu_sub                   4'b0001
`define alu_or                    4'b0010
`define alu_and                   4'b0011
`define alu_xor                   4'b0100
`define alu_signed_comparator     4'b0101
`define alu_unsigned_comparator   4'b0110
`define alu_equal                 4'b0111
`define alu_sll                   4'b1000
`define alu_srl                   4'b1001
`define alu_sra                   4'b1010


`define Performance_Count
