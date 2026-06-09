`timescale 1ns / 1ps

module tb_top();

    // 1. 对应 top.sv 的顶层物理引脚
    // 官方用了差分时钟 (Positive 和 Negative 是一对相反的线)
    logic i_sys_clk_p;
    logic i_sys_clk_n;
    logic i_uart_rx;

    wire o_uart_tx;
    wire [31:0] virtual_led;
    wire [39:0] virtual_seg;

    // 2. 例化官方顶层
    top uut (
        .i_sys_clk_p (i_sys_clk_p),
        .i_sys_clk_n (i_sys_clk_n),
        .i_uart_rx   (i_uart_rx),
        .o_uart_tx   (o_uart_tx),
        .virtual_led (virtual_led),
        .virtual_seg (virtual_seg)
    );

    // 3. 产生高速差分时钟 (假设外部晶振是 200MHz，周期 5ns)
    initial begin
        i_sys_clk_p = 0;
        i_sys_clk_n = 1;
    end
    always #2.5 begin
        i_sys_clk_p = ~i_sys_clk_p;
        i_sys_clk_n = ~i_sys_clk_n;
    end

    // 4. 上帝视角的仿真控制流
    initial begin
        // 串口 RX 默认保持高电平（空闲态）
        i_uart_rx = 1;

        // ? 核心黑客技巧：force 强制注入！
        // 无视 twin_controller，我们直接从内部强行接管虚拟开关
        force uut.virtual_sw = 64'b0;
        force uut.virtual_key = 8'b0;

        $display("Waiting for PLL to lock...");

        // 等待底层 PLL 锁相环启动 (通常需要几千纳秒)
        // 只有 uut.w_clk_rst (PLL Locked 信号) 变成 1，复位才会释放
        wait (uut.w_clk_rst == 1'b1);
        #100; // 锁定后稍微等一会儿让电平稳定
        $display("PLL Locked! CPU Engine Started...");

        // 拨下第0号拨码开关，触发测试跑分程序
        #500;
        force uut.virtual_sw[0] = 1'b1;

        // 让 CPU 挂机狂奔
        #500000;
        $finish;
    end

    // 5. 极速日志监控终端
    always @(posedge uut.student_top_inst.Core_cpu.cpu_clk) begin
        // 只有 PLL 稳定输出时钟后，才开始监控
        if (uut.w_clk_rst == 1'b1) begin
            $display("Time=%0t | PC=%h | Inst=%h", 
                     $time, 
                     uut.student_top_inst.Core_cpu.IFU_pc, 
                     uut.student_top_inst.Core_cpu.IDU_inst);
        end
    end

endmodule