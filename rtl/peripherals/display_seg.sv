`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 13:41:36
// Design Name: 
// Module Name: display
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


module display_seg (
    input  logic          clk    ,
    input  logic          rst    ,
    input  logic [31:0]   s      ,
    output logic [6:0]    seg1   ,
    output logic [6:0]    seg2   ,
    output logic [6:0]    seg3   ,
    output logic [6:0]    seg4   ,
    output logic [7:0]    ans
);
    logic  [4:0]   count;
    logic  [3:0]   digit1, digit2, digit3, digit4; 

    always@(posedge clk or posedge rst) begin
        if(rst)  
            count <= 0;
        else 
            count <= count + 1;
    end
       
    always @(*)
    case(count[4])
        0: begin
            ans = 8'b10101010;
            digit1 = s[7:4];
            digit2 = s[15:12];
            digit3 = s[23:20];
            digit4 = s[31:28];
        end
        
        1: begin
            ans = 8'b01010101;
            digit1 = s[3:0];
            digit2 = s[11:8];
            digit3 = s[19:16];
            digit4 = s[27:24];
        end

    endcase
    
    seg7 SEG1(.din(digit1),.dout(seg1));
    seg7 SEG2(.din(digit2),.dout(seg2));
    seg7 SEG3(.din(digit3),.dout(seg3));
    seg7 SEG4(.din(digit4),.dout(seg4));
endmodule