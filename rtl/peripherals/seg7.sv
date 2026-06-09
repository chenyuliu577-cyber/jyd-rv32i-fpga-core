`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/18 23:26:35
// Design Name: 
// Module Name: seg7
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


module seg7(
    input  logic [3:0]      din     ,
    output logic [6:0]      dout    
);
 
always_comb begin
    case(din)
        4'h0:dout = 7'b011_1111;
        4'h1:dout = 7'b000_0110;
        4'h2:dout = 7'b101_1011;
        4'h3:dout = 7'h4f;
        4'h4:dout = 7'h66;
        4'h5:dout = 7'h6d;
        4'h6:dout = 7'h7d;
        4'h7:dout = 7'h07;
        4'h8:dout = 7'h7f;
        4'h9:dout = 7'h6f;
        4'ha:dout = 7'h77;
        4'hb:dout = 7'h7c;
        4'hc:dout = 7'h39;
        4'hd:dout = 7'h5e;
        4'he:dout = 7'h79;
        4'hf:dout = 7'h71;
        default:dout = 7'h00;           
    endcase
end

endmodule