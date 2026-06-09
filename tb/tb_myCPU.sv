`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2025 03:50:55 PM
// Design Name: 
// Module Name: tb_myCPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_myCPU;
    reg clk;

    top uut (
        .i_sys_clk_p(clk),
        .i_sys_clk_n(~clk),
        .i_uart_rx(1'b1),
        .o_uart_tx(),
        .virtual_led(),  
        .virtual_seg()
    );

    //  clock 50MHz=2.5 20ns
    initial begin
        clk = 0;
        forever #2.5 clk = ~clk;
    end
endmodule
