`include "para.sv"
module IDU(
    input clock, input reset, input [31:0] inst, input[31:0] snpc, input [31:0] pc,
    input [31:0] rd_value, input [31:0] csrd, input [4:0] rd, input R_wen, input[3:0] csr_wen,
    input [31:0] EXU_rs1_in, input [31:0] EXU_rs2_in,
    input pred_taken_in, input [31:0] pred_target_in,
    output bpu_update_en, output bpu_actual_taken, output [31:0] bpu_actual_target,
    output IDU_mispredict, output [31:0] IDU_recover_pc,
    output [4:0] rd_next, output [2:0] funct3, output mret_flag, output ecall_flag, output fence_i_flag,
    output[31:0] branch_pc, output [31:0] rs1_value, output [31:0] rs2_value,
    output [31:0] add1_value, output[31:0] add2_value, output[3:0] csr_wen_next,
    output R_wen_next, output[31:0] rd_value_next, output mem_wen, output mem_ren,
    output inv_flag, output branch_flag, output jump_flag, output[3:0] alu_opcode,
    output [4:0] rs1, output[4:0] rs2, output [31:0] a0_value,
    output[31:0] mepc_out, output [31:0] mtvec_out, output [31:0] pc_out,
    input valid_last, output ready_last, input ready_next, output valid_next
);
    logic[31:0] csr_addr; logic [6:0] oprand; logic[6:0] opcode;
    logic [31:0] imm_I, imm_U, imm_R, imm_S, imm_B, imm_J, csrs, imm;

    assign ready_last = ready_next; assign valid_next = valid_last;
    assign oprand = inst[31:25]; assign opcode = inst[6:0];
    assign rs1 = inst[19:15]; assign rs2 = inst[24:20];
    assign funct3 = inst[14:12]; assign rd_next = inst[11:7];
    assign ecall_flag = (inst == 32'b00000000000000000000000001110011);
    assign mret_flag = (inst == 32'b00110000001000000000000001110011);
    assign fence_i_flag = (inst == 32'b00000000000000000001000000001111);
    assign csr_wen_next[0] = (opcode == `M_opcode && imm == 32'h341);
    assign csr_wen_next[1] = (opcode == `M_opcode && imm == 32'h342);
    assign csr_wen_next[2] = (opcode == `M_opcode && imm == 32'h300);
    assign csr_wen_next[3] = (opcode == `M_opcode && imm == 32'h305);
    assign R_wen_next = (opcode == `S_opcode || opcode == `B_opcode || opcode == 0)? 1'b0:1'b1;
    assign mem_wen = (opcode == `S_opcode); assign mem_ren = (opcode == `lw);
    assign jump_flag = (opcode == `jarl || opcode == `jal)? 1'b1:1'b0;
    assign inv_flag = (opcode == `B_opcode && (funct3 == 3'b101 || funct3 == 3'b111 || funct3 == 3'b000 ))? 1'b1:1'b0;

    logic idu_branch_taken;
    always_comb begin
        if (opcode == `B_opcode) begin
            case(funct3[2:1])
                2'b00: idu_branch_taken = (funct3[0] == 1'b0) ? (EXU_rs1_in == EXU_rs2_in) : (EXU_rs1_in != EXU_rs2_in);
                2'b10: idu_branch_taken = (funct3[0] == 1'b0) ? ($signed(EXU_rs1_in) < $signed(EXU_rs2_in)) : ($signed(EXU_rs1_in) >= $signed(EXU_rs2_in));
                2'b11: idu_branch_taken = (funct3[0] == 1'b0) ? (EXU_rs1_in < EXU_rs2_in) : (EXU_rs1_in >= EXU_rs2_in);
                default: idu_branch_taken = 1'b0;
            endcase
        end else idu_branch_taken = 1'b0;
    end
    assign branch_flag = idu_branch_taken; 

    logic [31:0] branch_pc_add, branch_rs1_add;
    assign branch_pc_add = pc + imm;
    assign branch_rs1_add = EXU_rs1_in + imm;
    assign branch_pc = (opcode == `jarl) ? (branch_rs1_add & 32'hfffffffe) : branch_pc_add;

    assign csr_addr = imm;
    assign rd_value_next = jump_flag ? snpc : ((|csr_wen_next) ? csrs : 0);
    assign pc_out = pc;
    assign add1_value = (opcode == `lui)? 0 : ((opcode == `jal || opcode == `auipc )? pc : EXU_rs1_in);
    assign add2_value = (opcode == `R_opcode || opcode == `B_opcode)? EXU_rs2_in : ((opcode == `M_opcode && funct3 == 3'b010)? rd_value_next : ((opcode == `M_opcode && funct3 == 3'b001)? 0 : imm));

    logic[3:0] alu_opcode_reg;
    always_comb begin
        alu_opcode_reg = `alu_add;
        case(opcode)
            `S_opcode, `lw, `lui, `auipc, `jal, `jarl: alu_opcode_reg = `alu_add;
            `addi: case(funct3)
                3'b000: alu_opcode_reg = `alu_add;
                3'b010: alu_opcode_reg = `alu_signed_comparator;
                3'b011: alu_opcode_reg = `alu_unsigned_comparator;
                3'b100: alu_opcode_reg = `alu_xor; 3'b110: alu_opcode_reg = `alu_or; 3'b111: alu_opcode_reg = `alu_and;
                3'b001: alu_opcode_reg = `alu_sll; 3'b101: alu_opcode_reg = (oprand[5] == 1'b0) ? `alu_srl : `alu_sra;
                default: alu_opcode_reg = `alu_add;
            endcase
            `R_opcode: case(funct3)
                3'b000: alu_opcode_reg = (oprand[5] == 1'b0) ? `alu_add : `alu_sub;
                3'b010: alu_opcode_reg = `alu_signed_comparator; 3'b011: alu_opcode_reg = `alu_unsigned_comparator;
                3'b100: alu_opcode_reg = `alu_xor; 3'b110: alu_opcode_reg = `alu_or; 3'b111: alu_opcode_reg = `alu_and;
                3'b001: alu_opcode_reg = `alu_sll; 3'b101: alu_opcode_reg = (oprand[5] == 1'b0) ? `alu_srl : `alu_sra;
                default: alu_opcode_reg = `alu_add;
            endcase
            `B_opcode: case(funct3[2:1])
                2'b00: alu_opcode_reg = `alu_equal; 2'b01: alu_opcode_reg = `alu_add;
                2'b10: alu_opcode_reg = `alu_signed_comparator; 2'b11: alu_opcode_reg = `alu_unsigned_comparator;
            endcase
        endcase
    end
    assign alu_opcode = alu_opcode_reg;

    assign imm_I = {{20{inst[31]}},inst[31:20]}; assign imm_U = {inst[31:12],12'd0}; assign imm_R = {25'd0,inst[31:25]};
    assign imm_S = {{20{inst[31]}},inst[31:25],inst[11:7]}; assign imm_B = {imm_S[31:11],imm_S[0],imm_S[10:1]}<<1;
    assign imm_J = {{11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21]}<<1;
    assign imm = (opcode == `lw || opcode == `addi || opcode == `jarl || opcode == `M_opcode)? imm_I:
        (opcode == `lui || opcode == `auipc)? imm_U: (opcode == `jal)? imm_J:
        (opcode == `B_opcode)? imm_B: (opcode == `S_opcode)? imm_S: (opcode == `S_opcode)? imm_R : 0;

    Reg_Stack Reg_Stack_inst0(
        .reset(reset), .clock(clock), .pc(pc), .ecall_flag(ecall_flag), .rs1(rs1), .rs2(rs2), .rd(rd), .rd_value(rd_value),
        .csr_addr(csr_addr), .R_wen(R_wen), .csr_wen(csr_wen), .csrd(csrd), .rs1_value(rs1_value), .rs2_value(rs2_value),
        .a0_value(a0_value), .csrs(csrs), .mepc_out(mepc_out), .mtvec_out(mtvec_out)
    );

    logic is_branch_inst, is_jump_inst;
    assign is_branch_inst = (opcode == `B_opcode);
    assign is_jump_inst   = (opcode == `jal) || (opcode == `jarl);

    assign bpu_update_en = is_branch_inst | is_jump_inst;
    assign bpu_actual_taken = is_jump_inst | (is_branch_inst & idu_branch_taken);
    assign bpu_actual_target = branch_pc;

    assign IDU_mispredict = (is_branch_inst | is_jump_inst) & (
        (bpu_actual_taken != pred_taken_in) | 
        (bpu_actual_taken & pred_taken_in & (bpu_actual_target != pred_target_in))
    );
    assign IDU_recover_pc = bpu_actual_taken ? bpu_actual_target : (pc + 4);
endmodule