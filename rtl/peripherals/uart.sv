`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 05:18:59 PM
// Design Name: 
// Module Name: uart
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

module uart #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 115200
)(
    input wire clk,
    input wire rst_n,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_ready,

    output reg tx,
    input wire [7:0] tx_data,
    input wire tx_start,
    output reg tx_busy
);
    localparam BAUD_DIV = CLK_FREQ / BAUD_RATE;

    reg [1:0] rx_state;
    reg [12:0] rx_cnt;
    reg [7:0] rx_shift;
    reg rx_d0, rx_d1, rx_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_d0 <= 1'b1;
            rx_d1 <= 1'b1;
            rx_d2 <= 1'b1;
        end else begin
            rx_d0 <= rx;
            rx_d1 <= rx_d0;
            rx_d2 <= rx_d1;
        end
    end

    wire rx_negedge = rx_d2 & ~rx_d1;

    reg [3:0] rx_bit_cnt;
    reg rx_ready_pulse;
    reg [15:0] rx_ready_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_state <= 0;
            rx_cnt <= 0;
            rx_bit_cnt <= 0;
            rx_shift <= 0;
            rx_data <= 0;
            rx_ready_pulse <= 0;
        end else begin
            rx_ready_pulse <= 0;
            case(rx_state)
                0: begin
                    if(rx_negedge) begin
                        rx_state <= 1;
                        rx_cnt <= BAUD_DIV >> 1;
                        rx_bit_cnt <= 0;
                    end
                end
                1: begin
                    if(rx_cnt == BAUD_DIV-1) begin
                        rx_cnt <= 0;
                        rx_state <= 2;
                    end else
                        rx_cnt <= rx_cnt + 1;
                end
                2: begin
                    if(rx_cnt == BAUD_DIV-1) begin
                        rx_cnt <= 0;
                        rx_shift <= {rx_d2, rx_shift[7:1]};
                        if(rx_bit_cnt == 7)
                            rx_state <= 3;
                        else
                            rx_bit_cnt <= rx_bit_cnt + 1;
                    end else
                        rx_cnt <= rx_cnt + 1;
                end
                3: begin
                    if(rx_cnt == BAUD_DIV-1) begin
                        rx_cnt <= 0;
                        rx_state <= 0;
                        rx_data <= rx_shift;
                        rx_ready_pulse <= 1'b1;
                    end else begin
                        rx_cnt <= rx_cnt + 1;
                    end
                end
                default: rx_state <= 0;
            endcase
        end
    end
    
    // rx_ready delay for half of BAUD_DIV
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_ready <= 1'b0;
            rx_ready_cnt <= 0;
        end else begin
            if (rx_ready_pulse) begin
                rx_ready <= 1'b1;
                rx_ready_cnt <= 0;
            end else if (rx_ready) begin
                if (rx_ready_cnt < BAUD_DIV - 1) begin
                    rx_ready_cnt <= rx_ready_cnt + 1;
                end else begin
                    rx_ready <= 1'b0;
                end
            end
        end
    end

    // tx state machine
    reg [3:0] tx_state;
    reg [12:0] tx_cnt;
    reg [3:0] tx_bit_cnt;
    reg [9:0] tx_shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_state <= 0;
            tx_busy <= 0;
            tx_cnt <= 0;
            tx_bit_cnt <= 0;
            tx_shift <= 10'b1111111111;
            tx <= 1'b1;
        end else begin
            case(tx_state)
                0: begin
                    tx_busy <= 0;
                    if(tx_start) begin
                        tx_shift <= {1'b1, tx_data, 1'b0};
                        tx_state <= 1;
                        tx_cnt <= 0;
                        tx_bit_cnt <= 0;
                        tx_busy <= 1;
                    end
                end
                1: begin
                    if(tx_cnt == BAUD_DIV-1) begin
                        tx_cnt <= 0;
                        tx <= tx_shift[0];
                        tx_shift <= {1'b1, tx_shift[9:1]};
                        if(tx_bit_cnt == 9)
                            tx_state <= 0;
                        else
                            tx_bit_cnt <= tx_bit_cnt + 1;
                    end else
                        tx_cnt <= tx_cnt + 1;
                end
            endcase
        end
    end

endmodule
