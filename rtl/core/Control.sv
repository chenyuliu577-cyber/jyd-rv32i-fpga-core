`timescale 1ns / 1ps
module Control(
    input clock, input reset, input [31:0] mtvec_out, input [31:0] mepc_out,
    input IDU_mispredict, input [31:0] IDU_recover_pc,
    input [31:0] Ex_result, input [31:0] MEM_Ex_result,
    input[31:0] IDU_rs1_value, input [31:0] IDU_rs2_value,
    input mret_flag, input ecall_flag, input fence_i_flag,
    input MEM_mem_ren, input [4:0] MEM_rd, input MEM_R_Wen,
    input [31:0] IDU_inst, input [4:0] IDU_rs1, input [4:0] IDU_rs2,
    input [4:0] EXU_rd, input EXU_mem_ren, input EXU_R_Wen,
    input IDU_valid, input EXU_valid, input MEM_valid,

    (* max_fanout = 32 *) output logic IFU_stall,
    (* max_fanout = 32 *) output logic IF_ID_stall,
    (* max_fanout = 32 *) output logic IF_ID_flush,
    output logic[31:0] EXU_rs1_in, output logic[31:0] EXU_rs2_in,
    output logic icache_clr,
    (* max_fanout = 32 *) output logic EXU_inst_clear,
    output logic [31:0] dnpc, output logic dnpc_flag
);
    logic [1:0] IDU_rs1_choice, IDU_rs2_choice;
    logic rs1_hazard, rs2_hazard, stall_condition;

    // 虚假冲突过滤
    logic [6:0] opcode;
    assign opcode = IDU_inst[6:0];
    logic idu_uses_rs1, idu_uses_rs2;
    assign idu_uses_rs1 = (opcode == 7'b0110011) | (opcode == 7'b0100011) | (opcode == 7'b1100011) |
                          (opcode == 7'b0000011) | (opcode == 7'b0010011) | (opcode == 7'b1100111);
    assign idu_uses_rs2 = (opcode == 7'b0110011) | (opcode == 7'b0100011) | (opcode == 7'b1100011);

    assign rs1_hazard = idu_uses_rs1 && (EXU_rd == IDU_rs1) && (EXU_rd != 5'b0);
    assign rs2_hazard = idu_uses_rs2 && (EXU_rd == IDU_rs2) && (EXU_rd != 5'b0);

    // 1 周期 Load-Use 停顿
    assign stall_condition = EXU_mem_ren && (rs1_hazard || rs2_hazard);

    assign IFU_stall = stall_condition;
    assign IF_ID_stall = stall_condition;

    logic real_mispredict;
    assign real_mispredict = IDU_mispredict & ~stall_condition;
    logic exception_hazard;
    assign exception_hazard = fence_i_flag | mret_flag | ecall_flag;

    assign dnpc_flag = real_mispredict | exception_hazard;
    assign IF_ID_flush = dnpc_flag;
    assign EXU_inst_clear = exception_hazard | stall_condition;
    assign icache_clr = fence_i_flag & EXU_valid;

    always_comb begin
        if (real_mispredict) dnpc = IDU_recover_pc;
        else if (mret_flag)  dnpc = mepc_out;
        else                 dnpc = mtvec_out;
    end

    // 4级流水线旁路：10 表示直接从写回寄存器(WBU_rd_value)获取
    always_comb begin
        case (IDU_rs1_choice)
            2'b01: EXU_rs1_in = Ex_result;
            2'b10: EXU_rs1_in = MEM_Ex_result;
            default: EXU_rs1_in = IDU_rs1_value;
        endcase
    end
    always_comb begin
        case (IDU_rs2_choice)
            2'b01: EXU_rs2_in = Ex_result;
            2'b10: EXU_rs2_in = MEM_Ex_result;
            default: EXU_rs2_in = IDU_rs2_value;
        endcase
    end

    Data_hazard Data_hazard_inst(
        .IDU_rs1(IDU_rs1), .IDU_rs2(IDU_rs2),
        .EXU_rd(EXU_rd), .EXU_R_Wen(EXU_R_Wen),
        .MEM_rd(MEM_rd), .MEM_R_Wen(MEM_R_Wen),
        .IDU_rs1_choice(IDU_rs1_choice), .IDU_rs2_choice(IDU_rs2_choice)
    );
endmodule
