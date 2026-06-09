`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 05:32:36 PM
// Design Name: 
// Module Name: tb_uart
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


`timescale 1ns / 1ps

module tb_uart;

    reg clk;
    reg rst_n;

    reg rx;
    wire tx;

    reg tx_start;
    reg [7:0] tx_data;
    wire tx_busy;
    wire [7:0] rx_data;
    wire rx_ready;

    uart #(
        .CLK_FREQ(50000000),  // 50MHz clock
        .BAUD_RATE(9600)      // baud?9600
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .tx(tx),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_busy(tx_busy),
        .rx_data(rx_data),
        .rx_ready(rx_ready)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    // 9600 buad = 1/9600 = 104166ns
    localparam BIT_PERIOD = 104166;

    initial begin
        rx = 1;         // IDLE, rx=1
        rst_n = 0;
        tx_start = 0;
        tx_data = 0;
        #1000;
        rst_n = 1;

        #500_000;  //  wait to stable state
        send_uart_byte(8'h41);  // send  'A'

        wait(rx_ready);
        #1;

        if (rx_data == 8'h41) begin
            $display("Received: %c", rx_data);
            send_hello_world();  // if receive 'A', send "helloworld"
        end

        #5_000_000;  // waiting for data send finish
        $display("Simulation finished.");
        $stop;
    end

    task send_uart_byte(input [7:0] data);
        integer i;
        begin
            //  start bit
            rx = 0;
            #(BIT_PERIOD);

            // low bit first
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BIT_PERIOD);
            end

            //  stop bit
            rx = 1;
            #(BIT_PERIOD);
        end
    endtask

    // send "helloworld"
    task send_hello_world;
        reg [7:0] message[0:9]; 
        integer i;
        begin
            // "helloworld"
            message[0] = "h";
            message[1] = "e";
            message[2] = "l";
            message[3] = "l";
            message[4] = "o";
            message[5] = "w";
            message[6] = "o";
            message[7] = "r";
            message[8] = "l";
            message[9] = "d";

            for (i = 0; i < 10; i = i + 1) begin
                wait(!tx_busy);
                tx_data = message[i];
                tx_start = 1;
              
                wait(tx_busy == 1'b1); // handshake    
                tx_start = 0;
                
                wait(tx_busy == 1'b0);
            end
        end
    endtask

endmodule

