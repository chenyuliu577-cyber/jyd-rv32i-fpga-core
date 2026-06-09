module CSR #(
    parameter CSR_WIDTH = 32,
    parameter RESET_VAL = 0
)(
    input clock,
    input reset,
    input [31:0] pc,
    input ecall_flag,
    input [31:0] csrd,
    input [3:0] csr_wen,
    output [31:0] mvendorid_out,
    output [31:0] marchid_out,
    output [31:0] mepc_out,
    output [31:0] mcause_out,
    output [31:0] mstatus_out,
    output [31:0] mtvec_out
);
    logic [31:0] mepc_in;
    logic [31:0] mcause_in;
    logic [31:0] mstatus_in;
    logic [31:0] mtvec_in;
    assign mepc_in = (ecall_flag) ? pc : csrd;
    assign mcause_in = (ecall_flag) ? 11 : csrd;
    assign mstatus_in = csrd;
    assign mtvec_in = csrd;
    assign mvendorid_out = 32'h79737978;
    assign marchid_out = 32'h16FBCBD;
Reg #(
    .WIDTH(CSR_WIDTH),
    .RESET_VAL(RESET_VAL)
) CSR_MEPC(
    .clock(clock),
    .reset(reset),
    .din(mepc_in),
    .dout(mepc_out),
    .wen(csr_wen[0] | ecall_flag)
);
Reg #(
    .WIDTH(CSR_WIDTH),
    .RESET_VAL(RESET_VAL)
) CSR_MCAUSE(
    .clock(clock),
    .reset(reset),
    .din(mcause_in),
    .dout(mcause_out),
    .wen(csr_wen[1] | ecall_flag)
);
Reg #(
    .WIDTH(CSR_WIDTH),
    .RESET_VAL(32'h1800)
) CSR_MSTATUS(
    .clock(clock),
    .reset(reset),
    .din(mstatus_in),
    .dout(mstatus_out),
    .wen(csr_wen[2])
);
Reg #(
    .WIDTH(CSR_WIDTH),
    .RESET_VAL(RESET_VAL)
) CSR_MTVEC(
    .clock(clock),
    .reset(reset),
    .din(mtvec_in),
    .dout(mtvec_out),
    .wen(csr_wen[3])
);
endmodule
