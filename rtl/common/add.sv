//module add #(
//    parameter BW = 32
//)
//(
//   input  logic          choose_add_sub, // 0为加法, 1为减法
//   input  logic [BW-1:0] add_1,
//   input  logic [BW-1:0] add_2,
//   output logic [BW-1:0] result
//);

//    logic [BW-1:0] op2;
//    // 如果是减法，第二个操作数取反；否则保持原样
//    assign op2 = choose_add_sub ? ~add_2 : add_2;
    
//    // 神仙操作：直接利用进位链。
//    // 如果是加法：add_1 + add_2 + 0
//    // 如果是减法：add_1 + (~add_2) + 1  (完美符合补码减法原理！)
//    assign result = add_1 + op2 + { {BW-1{1'b0}}, choose_add_sub };

//endmodule

