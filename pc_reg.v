/**
* IF 模块
* PC程序计数器
*/

`include "defines.v"

module pc_reg (
    input wire clk,  // 时钟信号
    input wire rst,  // 复位信号

    output reg[`InstAddrBus] pc,  // pc
    output reg ce  // 指令存储器使能信号
);
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            ce <= `ChipEnable; 
        end else begin
            ce <= `ChipDisable;  
        end
    end

    always @(posedge clk) begin
        if (ce == `ChipDisable) begin
            pc <= 32'h00000000;
        end else begin
            pc <= pc + 4'h4;
        end
    end
endmodule