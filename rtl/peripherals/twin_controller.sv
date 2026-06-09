`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 06:04:59 PM
// Design Name: 
// Module Name: twin_controller
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


module twin_controller(
    input wire clk,
    input wire rst_n,

    input wire rx_ready,
    input wire [7:0] rx_data,

    output reg tx_start,
    output reg [7:0] tx_data,
    input wire tx_busy,

    output reg [63:0] sw,
    output reg [7:0] key,
    input wire [39:0] seg,
    input wire [31:0] led
);

    typedef enum reg [0:0] {
        IDLE = 1'd0,
        SEND = 1'd1
    } state_t;

    reg [4:0] send_cnt;
    reg [7:0] status_buffer[0:17];
    reg [7:0] tx_data_next;
    reg tx_start_next;

    state_t current_state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        tx_start_next = 0;
        tx_data_next = tx_data;

        case(current_state)
            IDLE: begin
                if(rx_ready) begin
                    if(rx_data == 8'h80) begin
                        next_state = SEND;
                        tx_start_next = 0;
                    end else begin
                        next_state = IDLE;
                        if(rx_data[6:0] <= 72 && rx_data[6:0] >= 1) begin
                            tx_start_next = 0;
                        end
                    end
                end
            end
            SEND: begin
                if(~tx_busy) begin
                    tx_data_next = status_buffer[send_cnt];  
                    tx_start_next = 1;                      
                    if (send_cnt == 17)
                        next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_start <= 0;
            tx_data <= 8'd0;
        end else begin
            tx_start <= tx_start_next;
            tx_data <= tx_data_next;
        end
    end

    reg tx_start_d; // send_cnt should only add once in a tx process

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_start_d <= 0;
        end else begin
            tx_start_d <= tx_start;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            send_cnt <= 0;
        end else if(current_state == IDLE) begin
            send_cnt <= 0;
        end else if(current_state == SEND && tx_start && ~tx_start_d) begin
            send_cnt <= send_cnt + 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sw <= 64'd0;
            key <= 8'd0;
        end else if(rx_ready && rx_data != 8'h80 && rx_data != 8'h0) begin
            if(rx_data[6:0] <= 64)
                sw[rx_data[6:0] - 1] <= rx_data[7];
            else if(rx_data[6:0] <= 72)
                key[rx_data[6:0] - 65] <= rx_data[7];
        end
    end

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for(i = 0; i < 18; i = i + 1)
                status_buffer[i] <= 8'd0;
        end else if(rx_ready && rx_data == 8'h80 && current_state == IDLE) begin
            // seg: 40bit
            status_buffer[0]  <= seg[7:0];
            status_buffer[1]  <= seg[15:8];
            status_buffer[2]  <= seg[23:16];
            status_buffer[3]  <= seg[31:24];
            status_buffer[4]  <= seg[39:32];

            // key: 8bit
            status_buffer[5]  <= key;

            // sw: 64bit
            status_buffer[6]  <= sw[7:0];
            status_buffer[7]  <= sw[15:8];
            status_buffer[8]  <= sw[23:16];
            status_buffer[9]  <= sw[31:24];
            status_buffer[10] <= sw[39:32];
            status_buffer[11] <= sw[47:40];
            status_buffer[12] <= sw[55:48];
            status_buffer[13] <= sw[63:56];

            // led: 32bit
            status_buffer[14] <= led[7:0];
            status_buffer[15] <= led[15:8];
            status_buffer[16] <= led[23:16];
            status_buffer[17] <= led[31:24];
        end
    end

endmodule

