// 触发器模板
module Reg #(WIDTH = 1, RESET_VAL = 0) (
    input clock,
    input reset,
    input [WIDTH-1: 0]din,
    output logic [WIDTH-1: 0]dout,
    input wen                         
);
always @(posedge clock) begin
    if (reset) 
        dout <= RESET_VAL;
    else if (wen) 
        dout <= din;
    end
endmodule

